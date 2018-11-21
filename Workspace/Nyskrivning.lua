--[[

	har skrivit om Get and Fecth funktionerna, värkade gå fint tills att wow.exe crashar vid Event Trigger

]]--

-- +++ VARIABLE SETUP +++
debug = 1
datatable={}
--NumberofPagesScanned = 1


-- +++ FUNCTIONS +++

local function print(TEXT)
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT)
end

local function print_debug(TEXT)
	if debug == 1 then
	DEFAULT_CHAT_FRAME:AddMessage(RED_FONT_COLOR_CODE .. TEXT)
	end
end


-- Eventhandler Frame
MyFrame = CreateFrame("Frame")
MyFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
MyFrame:SetScript("OnEvent", Event_AuctionUpdate)
function Event_AuctionUpdate() 
	FiveSecondDelay()
  	print_debug("[AUCTION_ITEM_LIST_UPDATE]")
  
 	ReadTheAuctionHouse()
end


function MyAddon_Slash(msg)

    if not msg then
    	print("Slash is empty, try /ma scan")
    end

    msg = string.lower(msg)

    if (msg == "scan") then
    	QueryTheAuctionHouse("0")

    else
        print("Slash Error")
    end
end


-- Onload Function, Runs automaticly on load.  (Needs an xml file to work)
-- Binds slash commands to the addon  [ /ma ]
function MyAddon_OnLoad()
	print("[MyAddon]: Loaded")
	SlashCmdList["MYADDON"] = MyAddon_Slash;
	SLASH_MYADDON1 = "/MyAddon";
	SLASH_MYADDON2 = "/ma";
end


-- Query AH for Page$
function QueryTheAuctionHouse(l_Page)
	QueryAuctionItems("", 0, 0, 0, 0, 0, l_Page, 0, 0)
    		-- [name", minLevel, maxLevel, invTypeIndex, classIndex, subclassIndex, page, isUsable, qualityIndex]
    print_debug("Quering the AuctionHouse, Page: "..l_Page)

end



function ReadTheAuctionHouse()

	print_debug("Reading AuctionHouse, Page: "..NumberofPagesScanned)

	  

	for i=1, GetNumAuctionItems("list"), 1 do

	    local name, texture, count, quality, canUse, level, minBid, minIncrement,buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)   -- i == 1

	    if name == nil then name = "NULL" end
	    if texture == nil then texture = "NULL" end
	    if buyoutPrice == nil then buyoutPrice = "NULL" end
	    if highestBidder == nil then highestBidder = "NULL" end
	    if sold == nil then sold = "NULL" end
	    if canUse == nil then canUse = "NULL" end
	    if owner == nil then owner = "NULL" end
	    if sold == nil then sold = "NULL" end
	    

	    record = i .. ", " .. name .. ", " .. texture .. ", " .. count .. ", " .. quality .. ", " .. canUse .. ", " .. level .. ", " .. minBid .. ", " .. minIncrement .. ", " .. buyoutPrice .. ", " .. bidAmount .. ", " .. highestBidder .. ", " .. owner .. ", " .. sold
	   	print(record)
	    table.insert(datatable, record)

	    
 
	end
end

function FiveSecondDelay()
	print_debug("Sleeping 4")

	local delay
	delay=time()+4
	while time()<delay do
	end

end