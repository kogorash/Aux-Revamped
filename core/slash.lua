module 'aux.core.slash'

local T = require 'T'
local aux = require 'aux'
local info = require 'aux.util.info'
local post = require 'aux.tabs.post'

function status(enabled)
	return (enabled and aux.color.green'on' or aux.color.red'off')
end

_G.SLASH_AUX1 = '/aux'
function SlashCmdList.AUX(command)
	if not command then return end
	local arguments = aux.tokenize(command)
    local tooltip_settings = aux.character_data.tooltip
    if arguments[1] == 'scale' and tonumber(arguments[2]) then
    	local scale = tonumber(arguments[2])
	    aux.frame:SetScale(scale)
	    aux.account_data.scale = scale
    elseif arguments[1] == 'ignore' and arguments[2] == 'owner' then
	    aux.account_data.ignore_owner = not aux.account_data.ignore_owner
        aux.print('ignore owner ' .. status(aux.account_data.ignore_owner))
	elseif arguments[1] == 'post' and arguments[2] == 'stack' then
        aux.account_data.post_stack = not aux.account_data.post_stack
	    aux.print('post stack ' .. status(aux.account_data.post_stack))
    elseif arguments[1] == 'post' and arguments[2] == 'bid' then
        aux.account_data.post_bid = not aux.account_data.post_bid
	    aux.print('post bid ' .. status(aux.account_data.post_bid))
    elseif arguments[1] == 'post' and arguments[2] == 'duration' and  T.map('6', post.DURATION_2, '24', post.DURATION_8, '72', post.DURATION_24)[arguments[3]] then
        aux.account_data.post_duration = T.map('6', post.DURATION_2, '24', post.DURATION_8, '72', post.DURATION_24)[arguments[3]]
        aux.print('post duration ' .. aux.color.blue(aux.account_data.post_duration / 60 * 3 .. 'h'))
    elseif arguments[1] == 'crafting' and arguments[2] == 'cost' then
		aux.account_data.crafting_cost = not aux.account_data.crafting_cost
		aux.print('crafting cost ' .. status(aux.account_data.crafting_cost))
    elseif arguments[1] == 'tooltip' and arguments[2] == 'value' then
	    tooltip_settings.value = not tooltip_settings.value
        aux.print('tooltip value ' .. status(tooltip_settings.value))
    elseif arguments[1] == 'tooltip' and arguments[2] == 'daily' then
	    tooltip_settings.daily = not tooltip_settings.daily
        aux.print('tooltip daily ' .. status(tooltip_settings.daily))
    elseif arguments[1] == 'tooltip' and arguments[2] == 'merchant' and arguments[3] == 'buy' then
	    tooltip_settings.merchant_buy = not tooltip_settings.merchant_buy
        aux.print('tooltip merchant buy ' .. status(tooltip_settings.merchant_buy))
    elseif arguments[1] == 'tooltip' and arguments[2] == 'merchant' and arguments[3] == 'sell' then
	    tooltip_settings.merchant_sell = not tooltip_settings.merchant_sell
        aux.print('tooltip merchant sell ' .. status(tooltip_settings.merchant_sell))
    elseif arguments[1] == 'tooltip' and arguments[2] == 'disenchant' and arguments[3] == 'value' then
	    tooltip_settings.disenchant_value = not tooltip_settings.disenchant_value
        aux.print('tooltip disenchant value ' .. status(tooltip_settings.disenchant_value))
    elseif arguments[1] == 'tooltip' and arguments[2] == 'disenchant' and arguments[3] == 'distribution' then
	    tooltip_settings.disenchant_distribution = not tooltip_settings.disenchant_distribution
        aux.print('tooltip disenchant distribution ' .. status(tooltip_settings.disenchant_distribution))
    elseif arguments[1] == 'clear' and arguments[2] == 'item' and arguments[3] == 'cache' then
	    aux.account_data.items = {}
        aux.account_data.item_ids = {}
        aux.account_data.auctionable_items = {}
        aux.print('Item cache cleared.')
    elseif arguments[1] == 'populate' and arguments[2] == 'wdb' then
	    info.populate_wdb()
	elseif arguments[1] == 'sharing' then
		aux.account_data.sharing = not aux.account_data.sharing
		aux.print('sharing ' .. status(aux.account_data.sharing))
	elseif arguments[1] == 'show' and arguments[2] == 'hidden' then
		aux.account_data.showhidden = not aux.account_data.showhidden
		aux.print('show hidden ' .. status(aux.account_data.showhidden))
	
	-------------------------------------
	elseif arguments[1] == 'value' and arguments[2] == 'top' and arguments[3] == 'pctl' and arguments[4] then
		local v = tonumber(arguments[4])
		if v then
			v = _aux_clamp(v, 0.05, 1.00)
			aux.account_data.value_depth_fraction = v
			aux.print('value top percentile set to ' .. aux.color.blue(string.format('%.2f', v)))
		else
			aux.print('Usage: /aux value top pctl <0.05 .. 1.00>')
		end

	elseif arguments[1] == 'value' and arguments[2] == 'bot' and arguments[3] == 'pctl' and arguments[4] then
		local v = tonumber(arguments[4])
		if v then
			v = _aux_clamp(v, 0.00, 0.25)
			aux.account_data.value_trim_low = v
			aux.print('value bottom percentile set to ' .. aux.color.blue(string.format('%.2f', v)))
		else
			aux.print('Usage: /aux value bot pctl <0.00 .. 0.25>')
		end

	elseif arguments[1] == 'value' and arguments[2] == 'min' and arguments[3] == 'qty' and arguments[4] then
		local v = tonumber(arguments[4])
		if v then
			v = math.max(1, math.floor(v + 0.5))
			aux.account_data.value_min_total_qty = v
			aux.print('value min qty set to ' .. aux.color.blue(tostring(v)))
		else
			aux.print('Usage: /aux value min qty <integer >= 1>')
		end

	elseif arguments[1] == 'value' and not arguments[2] then
		local top    = aux.account_data.value_depth_fraction or 0.15
		local bottom = aux.account_data.value_trim_low or 0.00
		local minQty = aux.account_data.value_min_total_qty or 5
		aux.print('value settings (percentiles from cheapest side):')
		aux.print('- value top pctl = ' .. aux.color.blue(string.format('%.2f', top)))
		aux.print('- value bot pctl = ' .. aux.color.blue(string.format('%.2f', bottom)))
		aux.print('- value min qty = ' .. aux.color.blue(tostring(minQty)))

		

	-- Back-compat aliases (old names still work)
	elseif arguments[1] == 'value' and arguments[2] == 'depth' and arguments[3] then
		local v = tonumber(arguments[3])
		if v then
			v = _aux_clamp(v, 0.05, 1.00)
			aux.account_data.value_depth_fraction = v
			aux.print('value top percentile set to ' .. aux.color.blue(string.format('%.2f', v)))
		else
			aux.print('Usage: /aux value top pctl <0.05 .. 1.00>')
		end

	elseif arguments[1] == 'value' and arguments[2] == 'trimlow' and arguments[3] then
		local v = tonumber(arguments[3])
		if v then
			v = _aux_clamp(v, 0.00, 0.25)
			aux.account_data.value_trim_low = v
			aux.print('value bottom percentile set to ' .. aux.color.blue(string.format('%.2f', v)))
		else
			aux.print('Usage: /aux value bot pctl <0.00 .. 0.25>')
		end

	elseif arguments[1] == 'value' and arguments[2] == 'minqty' and arguments[3] then
		local v = tonumber(arguments[3])
		if v then
			v = math.max(1, math.floor(v + 0.5))
			aux.account_data.value_min_total_qty = v
			aux.print('value min qty set to ' .. aux.color.blue(tostring(v)))
		else
			aux.print('Usage: /aux value min qty <integer >= 1>')
		end

	-------------------------------------
	
	
	else
		aux.print('Usage:')
		aux.print('- scale [' .. aux.color.blue(aux.account_data.scale) .. ']')
		aux.print('- ignore owner [' .. status(aux.account_data.ignore_owner) .. ']')
		aux.print('- post bid [' .. status(aux.account_data.post_bid) .. ']')
        aux.print('- post duration [' .. aux.color.blue(aux.account_data.post_duration / 60 * 3 .. 'h') .. ']')
		aux.print('- post stack [' .. status(aux.account_data.post_stack) .. ']')
        aux.print('- crafting cost [' .. status(aux.account_data.crafting_cost) .. ']')
		aux.print('- tooltip value [' .. status(tooltip_settings.value) .. ']')
		aux.print('- tooltip daily [' .. status(tooltip_settings.daily) .. ']')
		aux.print('- tooltip merchant buy [' .. status(tooltip_settings.merchant_buy) .. ']')
		aux.print('- tooltip merchant sell [' .. status(tooltip_settings.merchant_sell) .. ']')
		aux.print('- tooltip disenchant value [' .. status(tooltip_settings.disenchant_value) .. ']')
		aux.print('- tooltip disenchant distribution [' .. status(tooltip_settings.disenchant_distribution) .. ']')
		aux.print('- clear item cache')
		aux.print('- populate wdb')
		aux.print('- sharing [' .. status(aux.account_data.sharing) .. ']')
		aux.print('- show hidden [' .. status(aux.account_data.showhidden) .. ']')
    end
end
