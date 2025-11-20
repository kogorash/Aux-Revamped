module 'aux.core.history'


--not using acecomm anymore
--[[AuxAddon = AceLibrary("AceAddon-2.0"):new("AceComm-2.0")   --im unsure this is done correctly but seems to work lol

local commPrefix = "AuxAddon";
AuxAddon:SetCommPrefix(commPrefix)

function AuxAddon:OnEnable()
	--self:RegisterComm(commPrefix, "GROUP", "OnCommReceive"); --for testing purposes, not really useful in real world I think
	self:RegisterComm(commPrefix, "GUILD", "OnCommReceive");
	--self:RegisterComm(commPrefix, "ZONE", "OnCommReceive");
end ]]--

local T = require 'T'
local aux = require 'aux'

local persistence = require 'aux.util.persistence'

local history_schema = {'tuple', '#', {next_push='number'}, {daily_min_buyout='number'}, {data_points={'list', ';', {'tuple', '@', {value='number'}, {time='number'}}}}}

local value_cache = {}

------------------------------------------------------------
-- User-facing tuning knobs (with sane defaults)
-- These can be edited in-game via /aux value depth|trimlow|minqty (see slash.lua patch)
------------------------------------------------------------
local today_samples = {}
local DEFAULT_DEPTH_FRACTION = 0.25   -- take up to this quantile from the cheap side (e.g., 40%)
local DEFAULT_TRIM_LOW       = 0.02   -- ignore the cheapest this fraction first (e.g., 5%)
local MIN_TOTAL_QTY_DEFAULT  = 5      -- require at least this many units to trust the daily calc

local function get_value_settings()
    local depth   = (aux.account_data and aux.account_data.value_depth_fraction) or DEFAULT_DEPTH_FRACTION
    local trimLow = (aux.account_data and aux.account_data.value_trim_low)       or DEFAULT_TRIM_LOW
    local minQty  = (aux.account_data and aux.account_data.value_min_total_qty)  or MIN_TOTAL_QTY_DEFAULT
    -- clamp to safe ranges
    if depth   < 0.05 then depth   = 0.05 end
    if depth   > 1.00 then depth   = 1.00 end
    if trimLow < 0.00 then trimLow = 0.00 end
    if trimLow > 0.25 then trimLow = 0.25 end
    if minQty  < 1    then minQty  = 1    end
    return depth, trimLow, minQty
end

------------------------------------------------------------
-- Simple helpers to avoid the '#' operator (compat/safety)
------------------------------------------------------------
local function list_length(list)
    local n = 0
    for _ in ipairs(list) do n = n + 1 end
    return n
end

local function list_is_empty(list)
    return next(list) == nil
end

------------------------------------------------------------
-- Window-VWAP daily value over [trim_low, depth_fraction]
-- If total quantity today < min_total_qty, FALL BACK to min unit price
------------------------------------------------------------
local function compute_window_vwap(entries, depth_fraction, trim_low, min_total_qty)
    if not entries or list_is_empty(entries) then return nil, false end

    table.sort(entries, function(a, b) return a.price < b.price end)

    local total_qty = 0
    for i = 1, list_length(entries) do total_qty = total_qty + (entries[i].qty or 0) end

    -- Fallback to minimum unit price if not enough quantity today
    if total_qty < (min_total_qty or MIN_TOTAL_QTY_DEFAULT) then
        local min_price = entries[1] and entries[1].price or nil
        return min_price, true
    end

    local df = depth_fraction or DEFAULT_DEPTH_FRACTION
    local tl = trim_low or DEFAULT_TRIM_LOW

    -- Convert to absolute quantity bounds
    local low_bound_qty  = total_qty * tl
    local high_bound_qty = total_qty * df

    -- Ensure the window has positive width; if not, expand minimally by 1 unit (or 1% of total)
    if high_bound_qty <= low_bound_qty then
        high_bound_qty = math.min(total_qty, low_bound_qty + math.max(1, total_qty * 0.01))
    end

    local vwap_num, vwap_den = 0, 0
    local cum_qty = 0

    for i = 1, list_length(entries) do
        local e = entries[i]
        local q = e.qty or 0
        if q > 0 then
            local next_cum = cum_qty + q

            -- overlap between [cum_qty, next_cum] and [low_bound_qty, high_bound_qty]
            local seg_start = math.max(cum_qty, low_bound_qty)
            local seg_end   = math.min(next_cum, high_bound_qty)
            local take = seg_end - seg_start

            if take > 0 then
                vwap_num = vwap_num + take * e.price
                vwap_den = vwap_den + take
            end

            cum_qty = next_cum
            if cum_qty >= high_bound_qty then break end
        end
    end

    if vwap_den > 0 then
        return vwap_num / vwap_den, false
    end

    -- Safety: if we couldn't build VWAP for any reason, fall back to min
    local min_price = entries[1] and entries[1].price or nil
    return min_price, true
end


------------------------------------------------------------

function aux.handle.LOAD2()
	data = aux.faction_data.history
end

do
	local next_push = 0
	function get_next_push()
		if time() > next_push then
			local date = date('*t')
			date.hour, date.min, date.sec = 24, 0, 0
			next_push = time(date)
		end
		return next_push
	end
end

function new_record()
	return T.temp-T.map('next_push', get_next_push(), 'data_points', T.acquire())
end

function read_record(item_key)
	local record = data[item_key] and persistence.read(history_schema, data[item_key]) or new_record()
	if record.next_push <= time() then
		push_record(record)
		write_record(item_key, record)
	end
	return record
end

function write_record(item_key, record)
	data[item_key] = persistence.write(history_schema, record)
	if value_cache[item_key] then
		T.release(value_cache[item_key])
		value_cache[item_key] = nil
	end
end

--pfUI.api.strsplit
local function AuxAddon_strsplit(delimiter, subject)
	if not subject then return nil end
	local delimiter, fields = delimiter or ":", {}
	local pattern = string.format("([^%s]+)", delimiter)
	string.gsub(subject, pattern, function(c) fields[table.getn(fields)+1] = c end)
	return unpack(fields)
  end

--taken from Atlasloot Update announcing code

AUX_data_sharer = CreateFrame("Frame")
AUX_data_sharer:RegisterEvent("CHAT_MSG_CHANNEL")
AUXplayerName = UnitName("player")


AUX_data_sharer:SetScript("OnEvent", function()
	if event == "CHAT_MSG_CHANNEL" and aux.account_data.sharing == true then
		local _,_,source = string.find(arg4,"(%d+)%.")
		if source then
			_,name = GetChannelName(source)
		end
		if name == "LFT" then
			local msg, item_key, munit_buyout_price = AuxAddon_strsplit(",", arg1) --using , as a seperator because item_key contains a :
			if msg == "AuxData" then
				if arg2 ~= AUXplayerName then
					local unit_buyout_price = tonumber (munit_buyout_price)
					if unit_buyout_price and item_key then
					--print("received data:" .. msg .. "," .. item_key .. "," .. unit_buyout_price); --for testing (print comes from PFUI)
						local item_record = read_record(item_key)
						if unit_buyout_price > 0 and unit_buyout_price < (item_record.daily_min_buyout or aux.huge) then
							item_record.daily_min_buyout = unit_buyout_price
							write_record(item_key, item_record)
							--print("wrote data"); --for testing (print comes from PFUI)
						end
					end
				end
			end
		end
	end
  end)

function M.process_auction(auction_record, pages)
	local item_record = read_record(auction_record.item_key)
	local unit_buyout_price = ceil(auction_record.buyout_price / auction_record.aux_quantity)
	local item_key = auction_record.item_key
	
	
	--if unit_buyout_price > 0 and unit_buyout_price < (item_record.daily_min_buyout or aux.huge) then
	--	item_record.daily_min_buyout = unit_buyout_price
	--	write_record(auction_record.item_key, item_record)
	
	-- Accumulate today's entries for this item
    if unit_buyout_price > 0 then

		local rec = today_samples[item_key]
	    if not rec then
	        rec = { entries = {}, total_qty = 0 }
	        today_samples[item_key] = rec
	    end
	    table.insert(rec.entries, { price = unit_buyout_price, qty = auction_record.aux_quantity })
	    rec.total_qty = rec.total_qty + auction_record.aux_quantity
	
	    local depth_fraction, trim_low, min_total_qty = get_value_settings()
	    local v = compute_window_vwap(rec.entries, depth_fraction, trim_low, min_total_qty)
	
	    if v and v > 0 then
	        item_record.daily_min_buyout = v
	        write_record(item_key, item_record)
	    end
	
	
		--AuxAddon:SendCommMessage("GUILD", item_key, unit_buyout_price) relies on acecomm
		--if aux.account_data.sharing == true then
		if aux.account_data.sharing == true and pages then
			if pages < 15 then --to avoid sharing data when people do searches without a keyword "full scans"
				if GetChannelName("LFT") ~= 0 then
					ChatThrottleLib:SendChatMessage("BULK", nil, "AuxData," .. item_key .."," .. unit_buyout_price , "CHANNEL", nil, GetChannelName("LFT")) --ChatThrottleLib fixed for turtle by Candor https://github.com/trumpetx/ChatLootBidder/blob/master/ChatThrottleLib.lua
				  	--print("sent")
				end
		 	end
		end
	end
end

--[[ function AuxAddon:OnCommReceive(prefix, sender, distribution, item_key, unit_buyout_price) --copied code from process_auction. <- code for when using acecomm
	print("received data"); --for testing (print comes from PFUI)
	local item_record = read_record(item_key)
	if unit_buyout_price > 0 and unit_buyout_price < (item_record.daily_min_buyout or aux.huge) then
		item_record.daily_min_buyout = unit_buyout_price
		write_record(item_key, item_record)
		--print("wrote data"); --for testing (print comes from PFUI)
	end
end ]]--

function M.data_points(item_key)
	return read_record(item_key).data_points
end

function M.value(item_key)
	if not value_cache[item_key] or value_cache[item_key].next_push <= time() then
		local item_record, value
		item_record = read_record(item_key)
		if getn(item_record.data_points) > 0 then
			local total_weight, weighted_values = 0, T.temp-T.acquire()
			for _, data_point in item_record.data_points do
				local weight = .99 ^ aux.round((item_record.data_points[1].time - data_point.time) / (60 * 60 * 24))
				total_weight = total_weight + weight
				tinsert(weighted_values, T.map('value', data_point.value, 'weight', weight))
			end
			for _, weighted_value in weighted_values do
				weighted_value.weight = weighted_value.weight / total_weight
			end
			value = weighted_median(weighted_values)
		else
			value = item_record.daily_min_buyout
		end
		value_cache[item_key] = T.map('value', value, 'next_push', item_record.next_push)
	end
	return value_cache[item_key].value
end

function M.market_value(item_key)
	return read_record(item_key).daily_min_buyout
end

function weighted_median(list)
	sort(list, function(a,b) return a.value < b.value end)
	local weight = 0
	for _, v in ipairs(list) do
		weight = weight + v.weight
		if weight >= .5 then
			return v.value
		end
	end
end

function push_record(item_record)
	if item_record.daily_min_buyout then
		tinsert(item_record.data_points, 1, T.map('value', item_record.daily_min_buyout, 'time', item_record.next_push))
		while getn(item_record.data_points) > 11 do
			T.release(item_record.data_points[getn(item_record.data_points)])
			tremove(item_record.data_points)
		end
	end
	item_record.next_push, item_record.daily_min_buyout = get_next_push(), nil
end
