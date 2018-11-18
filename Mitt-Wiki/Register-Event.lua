
frameName = CreateFrame("Frame")

frameName:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
frameName:SetScript("OnEvent", EventHandler)

function EventHandler(e)
	-- Do Shiet!!
end
