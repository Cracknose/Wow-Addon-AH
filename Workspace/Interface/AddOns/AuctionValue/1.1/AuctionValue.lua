

--ON LOAD
local function print(TEXT)
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT);
end

print("[AuctionValue-1.1] - Loaded")


-- EVENTS
AH_Open:RegisterEvent("AUCTION_HOUSE_SHOW")
AH_Open:SetScript("OnEvent", AhOpen)

AH_Closed:RegisterEvent("AUCTION_HOUSE_CLOSED")
AH_Closed:SetScript("OnEvent", AhClosed)

AuctionsChanged:RegisterEvent("AUCTION_OWNED_LIST_UPDATE")
AuctionsChanged:SetScript("OnEvent", GetAuctions)