--[[

	Att Göra
		Highest bidder och Sold variablerna kan komma ut tomma, och det krashar Lua
]]--


 --local MyFrame = CreateFrame("Frame")

function MyEventListener(e)
  DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. e)
end

i = 5

QueryAuctionItems("", 0, 0, 0, 0 ,0 ,0 ,0 ,0)

name, texture, count, quality, canUse, level, minBid, minIncrement,buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)

record = name .. ", " .. texture .. ", " .. count .. ", " .. quality .. ", " .. canUse .. ", " .. level .. ", " .. minBid .. ", " .. minIncrement .. ", " .. buyoutPrice .. ", " .. bidAmount .. ", " .. highestBidder .. ", " .. owner .. ", " .. sold


DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. i..":  "..record)

--MyFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
--MyFrame:RegisterScript("MyEventListener")