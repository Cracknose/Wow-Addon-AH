--[[

	1,  CanSendAuctionQuery() värkar alltid returna '1'
	2,  MyScanner(),  lägg till record i en list

]]--

local function print(TEXT)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT);
end

function MyAddon_Slash(msg)

    if not msg then
    	print("Slash is empty, try /ma scan")
    end

    msg = string.lower(msg)

    if (msg == "scan") then
        MyScanner();
    else
        print("Slash Error")
    end
end

function MyAddon_OnLoad()
	print("FUCKING LOADED")
	SlashCmdList["MYADDON"] = MyAddon_Slash;
	SLASH_MYADDON1 = "/MyAddon";
	SLASH_MYADDON2 = "/ma";
end








function MyScanner()

	print(CanSendAuctionQuery())
	--[[
	if CanSendAuctionQuery() == 0 then
 	print("Cannot Query")
 	return true
	end
	]]--

    QueryAuctionItems("", 0, 0, 0, 0, 0, 0, 0, 0)
    print("Querried ;) ")
    print("Number of Auctions:  " .. GetNumAuctionItems("list") )

    for i=1, GetNumAuctionItems("list"), 1 do
        local name, texture, count, quality, canUse, level, minBid, minIncrement,buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)   -- i == 1

        if buyoutPrice == nil then buyoutPrice = "" end
        if highestBidder == nil then highestBidder = "" end
        if sold == nil then sold = "" end
        if canUse == nil then canUse = "" end
        if owner == nil then owner = "" end

        record = name .. ", " .. texture .. ", " .. count .. ", " .. quality .. ", " .. canUse .. ", " .. level .. ", " .. minBid .. ", " .. minIncrement .. ", " .. buyoutPrice .. ", " .. bidAmount .. ", " .. highestBidder .. ", " .. owner .. ", " .. sold
        print(i..":  "..record)
    end

end