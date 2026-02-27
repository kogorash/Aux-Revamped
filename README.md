# Aux-Revamped

# 2026.02.21
Auto-buyout has been reworked for automated use.

<details>
<summary>📷 1. "POST" tab: Manually specify the maximum unit price for the item at which it will be automatically purchased </summary>
<br>On my server, "Black Lotus" has an average minimum price of 11,20. 
<br>I want to instantly/automatically buy any amount if the price is below 10,30
<br><br> <img width="725" height="488" alt="1" src="https://github.com/user-attachments/assets/9d0e1ff3-3301-48d1-b14b-16f01c54721e" />
</details> 


<details>
<summary>📷 2. "SEARCH" tab: Add this item to your favorites and activate auto-purchase </summary>
<img width="730" height="471" alt="2" src="https://github.com/user-attachments/assets/d0525925-7fd7-4a8b-913e-82992399ada5" />
</details> 

3. Use standart search or optionally  "Run favorite auto-buyout scan" for all activated items. 

Be careful with the settings so you don't waste all your money on an incorrectly configured price!!!
I use it for purchasing large quantities of herbs, because players on our server constantly list one item instead of a pack of 20.


# 2025.11.24
Fixed a bug where it was impossible to place items with charges, like weapon oil

A button for manual price setting has been added. Useful for accurately calculating the cost of crafting an item/enchantment, taking into account the ingredients from a merchant.

<details>
<summary>📷 Manual price set </summary>

<img width="1433" height="826" alt="123" src="https://github.com/user-attachments/assets/49606f98-1074-4c8f-ba70-ce6430cd771e" />
</details> 





# 2025.11.20

A patch has been added to more accurately calculate the average price, taken from reddit:
https://www.reddit.com/r/turtlewow/comments/1nd883h/update_to_the_value_calculation_method_of_the_aux/

recommended aux settings:
* /aux value top pctl 0.20 (The cheapest 20% of items will be used for the calculation)
* /aux value bot pctl 0.04 (cut off random sales at a non-market cheap price)
* /aux sharing off (Disable the use of other players' scanning results. It's inconvenient, I know, but this data can significantly distort your estimated prices.)

if you want to fully reset old history - as a first step you should delete this file: \WoW\WTF\Account\accountname\SavedVariables\aux-addon.lua (before applying /aux settings above)



# Upstream repository 

------------------------------------------------------------------------------------


Changelog (for those who don't dig into reading all the commits):
* A refreshed and transparent UI update for the classic Aux auction addon.
![image](https://github.com/user-attachments/assets/5657e872-3cd3-437a-874a-b3e2732f06f4)


![image](https://github.com/user-attachments/assets/86cf212b-675f-4008-bd04-c23ec041f138)


![image](https://github.com/user-attachments/assets/64300e05-27b8-466f-84cc-965be9a7cc7b)


Hey everyone,

I absolutely love Aux, but I’ve always thought the UI could use some polish — and I know many of you agree. So, I took some time to give it a facelift!

I’ve updated it to use Blizzard’s classic background and border, refined all the highlight textures, and tweaked the text positioning for a cleaner, more cohesive look.

Additionally, I’ve improved the “money” fonts so the numbers now match the color of their respective currency symbols, making values easier to read at a glance. I also added dynamic vendor price and stacks price calculations, including profit/loss display directly in the posting tab.

On top of that, I implemented a built-in 40% reduction to deposit fees. It’s not a perfect match to the original Turtle WoW formula, but it’s a lot closer than the default values.

It’s not perfect yet, but it’s a solid step forward!

As always, feel free to share any ideas or submit pull requests. :)


  
# aux Turtle

* Shares some price data through the LFT chat when searching the AH, use **/aux sharing** to disable sending and receiving data.
* Accurate auction durations for Turtle WoW.
* Autocompletion for custom Turtle WoW items.

# aux - WoW 1.12 AddOn

The most advanced auction house addOn for the 1.12 client with some features more advanced than anything even on retail.

## Core Features

### General
* Completely independent replacement for the Blizzard interface.
* Elegant look based on the retail addOn TSM.
* Many convenient shortcuts.
* Convenient access to the unaltered Blizzard interface.

### Search
* Automatic scanning of all pages for a query.
* Saving of recent and favorite queries.
* History of result listings with internet browser-like interface.
* Advanced search filters which can be combined with logical operators.
* Autocompletion for entering filters.
* Concise listings cleary showing the most important information.
* Sorting by percentage of historical value and unit price.
* Sorting across all scanned pages.
* Quick buying from any page without rescanning everything.
* Real time mode which continuously scans the last page.

### Post
* Automatic assembling and posting of multiple stacks.
* Automatic scanning of existing auctions.
* Concise listing of existing auctions.
* Undercutting of existing auctions by click.
* Concise listing of inventory items excluding the non auctionable.
* Manual exclusion of specific items from the inventory listing.
* Saving post configuration per item.
* Efficient price input inspired by the retail addOn TSM.

### History
* Automatic gathering of historical data from all scans.
* Automatic collection of vendor prices.
* Intricate calculations for a reliable historical value.
* Tooltip with historical value, vendor prices and disenchant value.
* Efficient storage of data.

## Slash Commands
### General
**/aux** (Lists the settings)<br/>
**/aux scale _factor_** (Scales the aux GUI by _factor_)<br/>
**/aux ignore owner** (Disables waiting for owner names when scanning. Recommended)<br/>
**/aux post bid** (Adds a bid price listing to the post tab)<br/>
**/aux crafting cost** (Toggles the crafting price information)<br/>
**/aux post duration _hours_** (Sets the default auction duration to _2_/_8_/_24_ hours)<br/>
### Tooltip
**/aux tooltip value**<br/>
**/aux tooltip daily**<br/>
**/aux tooltip disenchant value**<br/>
**/aux tooltip disenchant distribution**<br/>
**/aux tooltip vendor buy**<br/>
**/aux tooltip vendor sell**<br/>

## Usage
### General
For the auction listings in the search, auctions and bids tabs the following shortcuts are available.
- Double-click on a row with blue colored count to expand it.
- Alt-left-click on the selected row for buyout/cancel.
- Alt-right-click on the selected row for bid/cancel.
- Right-click on a row to start a search for the auctioned item.
- Control-click on a row the show a preview in the wardrobe frame.
- Shift-click on a row to copy the link to the chatframe.
- Left-click on a header to sort.
- Right-click on a header of a price column to switch between unit and stack price.

Furthermore
- Double-click in editboxes will highlight everything.

### Search
- Hitting tab in the search box will accept an autocompletion.
- Dragging inventory items to the search box or right-clicking them will start a search.
- Right-clicking item links will start a search.

#### Search Results
![Alt text](http://i.imgur.com/hI6ODqM.png)
- Bid prices for your own active bids are colored in green.
- Bid prices for other auctions with an active bid are colored in orange.

#### Saved Searches
![Alt text](http://i.imgur.com/dICDnxR.png)
- When hovering over an entry the tooltip shows a longer and more nicely formatted version.
- Left-click on an entry will start a search.
- Right-click on an entry will show a menu with various options, including toggling Auto Buy.
- Shift-left-click on an entry will copy a search to the search box.
- Shift-right-click on an entry will add a search to the existing query in the search box.

#### Filter Builder
![Alt text](http://i.imgur.com/8hilZc9.png)
While it is faster to type filters directly into the search box this sub-tab serves as a tutorial to learn how to formulate queries.
The filters on the left side are Blizzard filters which may reduce the number of pages to be scanned and those on the right side are post filters which do not affect the scan time but can be combined with logical operators to formulate very complex filters.
### Post
![Alt text](http://i.imgur.com/otzOT2I.png)
- When entering prices **g**, **s** and **c** denote gold, silver and copper respectively.
- A price value without explicit denotations will count as gold. (e.g., 10.5 = 10g50s)
- Price values can contain decimals. (e.g., 1.5g = 1g50s)
- Right-clicking an item in the inventory listing will start a search.
- Right-clicking a bag item will select it in the listing.
- In the listing of bids/buyouts a red price is undercutting stack/unit price.
- Clicking an entry in the in the listings of bids/buyouts of existing auctions will undercut with your bid stack/buyout unit price.
- Double-click in the bids/buyouts listings will also match the stack size.

### Auctions
![Alt text](http://i.imgur.com/6HjaIo2.png)

### Bids
![Alt text](http://i.imgur.com/NOjPKNW.png)

## Search Filters
AddOns do not have any additional Blizzard filters available to them beyond the ones in the default auction house interface, nor do they have any other ways to combine them.
Of course it is possible for an addOn to apply arbitrary filters after the Blizzard query but only the Blizzard query will affect the number of pages to be scanned and thus the time it takes for a scan.
Since the Vanilla API will only let you request a page every 4 seconds having no Blizzard query in your filter can lead to very long scan times.

aux queries are separated by semicolons and always contain exactly one Blizzard query. The Blizzard query may be empty, i.e., all pages are scanned, which can be useful for collecting historical data.
The real time mode only supports empty Blizzard queries.
Semicolons always mean "or", i.e., **q1;q2;q3** means all items matching **q1** or **q2** or **q3** will be listed.

The parts of individual queries are separated by slashes, e.g., **q1p1/q1p2;q2p1/q2p2/q2p3**. All parts either belong to the Blizzard filter or the post processing filter.

Blizzard filters can be created through the form on the left side of the "New Filter" sub-tab of the "Search" tab or typed directly into the search box.
For learning to write queries you can fill in the form, add the query to the search box with the "Add" or "Replace" buttons and inspect the generated output until you feel comfortable typing them out yourself.
For the most part it should be rather intuitive.
The first part is special in that if it doesn't match any specific filter keyword it will be treated as a Blizzard name search. E.g., a query consisting only of **felcloth** would list the items Felcloth, Pattern: Felcloth Hood, Felcloth Bag etc.
Usually you would want to use the **exact** modifier which only matches auctions where the name, apart from case, exactly equals the first part of the query.
**exact** is the only modifier which is part Blizzard and part post filter, though it is mostly treated as a Blizzard filter. **exact** will tailor the Blizzard query as well as possible towards the item searched (level range, item class/subclass/slot, quality ...) and it cannot be used together with Blizzard filters for these properties.

Post processing filters are more flexible.
They are specified using the filter primitives you find on the right side of the "New Filter" sub-tab and can be combined with **and**, **or** and **not** using polish notation (https://en.wikipedia.org/wiki/Polish_notation).
Filter parts other than the first which don't match any specific filter, just like the first part is treated as a Blizzard name filter, are treated as a tooltip filter.
For using a tooltip filter as the first filter part there is an explicit **tooltip** modifier.

Here are some queries I use myself for illustration:

**or/and2/profit/5g/percent/60/and3/bid-profit/5g/bid-percent/60/left/30m**<br/>
This filter will search the whole auction house for auctions either with a buyout price of 5g or more below market value and 60% or less of the market value or a bid price for which the same is true and in addition only 30m or less remaining.

**wrangler's wristbands/exact/or2/and2/+3 agility/+3 stamina/+5 stamina/price/1g**<br/>
This will search for wrangler's wristband with 3/3 monkey or 5 stam suffixes for at most 1g buyout price.

**recipe/usable/not/libram**<br/>
This will scan for usable recipes and exclude those with "libram" in the tooltip (i.e., librams)

**armor/cloth/50/intellect/stamina**<br/>
This will scan the auction house for cloth armor which has a requirement of at least lvl 50 as well both intellect and stamina stats.

## Historical Value

aux condenses the prices you've scanned during a day (midnight to midnight) into a single value, similarly to retail Auctioneer's "stat-simple" module.
This daily value is calculated as the minimum buyout of the day which in practice gives a similar enough value to that of retail TSM while using much less memory.
Limiting the memory usage is important because like Auctioneer and unlike TSM aux is using a day based instead of scan based interval and thus has to store the daily progress in the savedvariables.
Finally these daily values are collected in a list of the last 11 of them from which the market value is taken as the median. The values are weighted by their age but it doesn't have a large effect unless they're older than a month.

The bottom line is that you get a fairly accurate market value for both very active markets as well as rarer items that has a reasonably short reaction time to market changes, recovers easily and never needs to be reset while still being reasonably stable and hard to manipulate and dealing with outliers very well, not getting distorted by multiple scans per day, not needing a single full scan per day but instead naturally picking up every price you scan while going about your usual business, letting you focus on a certain part of the auction house by scanning only that part regularly and avoiding information overload by giving you a single concise value for the tooltip.
