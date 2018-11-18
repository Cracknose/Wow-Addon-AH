--[[

AuctionValue AddOn by Floorf
	Calculates the worth of all you auctions



Todo:
	
	1.1  Add number of unique auctions in ATW Message
	1.2  Create a GUI window
	1.3  Create a non-volatile Config for Gui placement

]]--


--ON LOAD
local function print(TEXT)
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT);
end

print("[AuctionValue] - Loaded")


-- VARIABLES
local isclosed = 1

local isAhOpen = CreateFrame("Frame")
local isAhClosed = CreateFrame("Frame")
local AuctionsChanged = CreateFrame("Frame")
local AuctionValue = 0

-- FUNCTIONS
local function GetAuctions(e)	
	local total = 0
	for i=1, GetNumAuctionItems("owner") do
		local name, texture, count, quality, usable, level, start_price, min_increment, buyout_price, high_bid, high_bidder, owner, sale_status = GetAuctionItemInfo("owner", i) -- SPARA DEN HÄR STRÄNGEN
		total = total + buyout_price
	end
		total = total / 100
		total = total / 100
		AuctionValue = total
end
			
	
local function printATW()
	local ATW = AuctionValue
	print("[AuctionValue] - ATW: "..ATW)
end

local function AhOpen(e)
	-- print("AH - Open")
	isclosed = 0
end

local function AhClosed(e)
	if isclosed == 0 then
		-- print("AH - Closed")	
		isclosed = 1
		printATW()
	end
end

-- EVENTS
isAhOpen:RegisterEvent("AUCTION_HOUSE_SHOW")
isAhOpen:SetScript("OnEvent", AhOpen)

isAhClosed:RegisterEvent("AUCTION_HOUSE_CLOSED")
isAhClosed:SetScript("OnEvent", AhClosed)

AuctionsChanged:RegisterEvent("AUCTION_OWNED_LIST_UPDATE")
AuctionsChanged:SetScript("OnEvent", GetAuctions)






-- Check if Auctionhouse is displayed
-- if(AuctionFrame:IsVisible()==1)

-- Get OwnedAuctions
-- Get into list