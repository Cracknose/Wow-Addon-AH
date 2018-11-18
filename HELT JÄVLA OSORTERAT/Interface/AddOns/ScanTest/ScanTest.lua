

-- Setup
local AH_Open = CreateFrame("Frame")
local Scan_Frame = CreateFrame("Frame")


local function print(TEXT)
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT);
end

print("[ScanTest-1.0] - Loaded")

function AhOpen(e)
	print("[ScanTest-1.0] - AH Open")	

	if CanSendAuctionQuery() == 1 then
		print("[ScanTest-1.0] - Attemping to Query")
		MyScan()		
	else
		print("[ScanTest-1.0] - Error: AhOpen")
	end

end

function MyScan()
		
		QueryAuctionItems("", 0, 0, 0, 0 ,0 ,0 ,0 ,0)
		ScanUpdate()
end

function ScanUpdate()
	for i=1, GetNumAuctionItems("list"), 1 do
		local name, texture, count, quality, canUse, level, minBid, minIncrement,buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)   -- i == 1

			if buyoutPrice == nil then buyoutPrice = "N/A" end
			if highestBidder == nil then highestBidder = "N/A" end
			if sold == nil then sold = "N/A" end

			record = name .. ", " .. texture .. ", " .. count .. ", " .. quality .. ", " .. canUse .. ", " .. level .. ", " .. minBid .. ", " .. minIncrement .. ", " .. buyoutPrice .. ", " .. bidAmount .. ", " .. highestBidder .. ", " .. owner .. ", " .. sold
			print(i..":  "..record)
	end
end

	

AH_Open:RegisterEvent("AUCTION_HOUSE_SHOW")
AH_Open:SetScript("OnEvent", AhOpen)

Scan_Frame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
Scan_Frame:SetScript("OnEvent", ScanUpdate)


-- Scan_Frame:SetScript("ScanUpdate")



-- Bind '/' commands

-- Check if AH is Shown och closed

-- CanSendAuctionQuery()  check GETALL

-- Scan AH

-- Save Data into File named by date&time


-- Analyze