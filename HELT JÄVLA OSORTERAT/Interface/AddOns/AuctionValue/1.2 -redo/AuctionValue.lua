

--ON LOAD
local function print(TEXT)
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT);
end

print("[AuctionValue-1.1] - Loaded")




local function AhOpen(e):
	print("bös")
end

local function AhClosed(e):
	print("bös")
end

local function GetAuctions(e):
	print("bös")
end

local function GetBids(e):
	print("bös")
end



-- EVENTS
AH_Open:RegisterEvent("AUCTION_HOUSE_SHOW")
AH_Open:SetScript("OnEvent", AhOpen)

AH_Closed:RegisterEvent("AUCTION_HOUSE_CLOSED")
AH_Closed:SetScript("OnEvent", AhClosed)

AuctionsChanged:RegisterEvent("AUCTION_OWNED_LIST_UPDATE")
AuctionsChanged:SetScript("OnEvent", GetAuctions)

BidChanged:RegisterEvent("AUCTION_BIDDER_LIST_UPDATE")
BidChanged:SetScript("GetBids")