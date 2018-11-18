-- LearnScan

local function print(TEXT)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT);
end


if CanSendAuctionQuery() == 1 then
  print("Can Query")
end

SlashCmdList["MYSCAN"] = MySlashCommand;
    SLASH_MYSCAN1 = "/MyScan"
    SLASH_MYSCAN2 = "/myscan"
    SLASH_MYSCAN3 = "/ms"



local function MySlashCommand(msg)
    if (msg == "scan" or "Scan") then
        MyScanner();


function MyScanner()

    QueryAuctionItems("", 0, 0, 0, 0, 0, 0, 0, 0)
    print("Querried ;) ")
    print("Number of Auctions:  " .. GetNumAuctionItems("list") )

    for i=1, GetNumAuctionItems("list"), 1 do
        local name, texture, count, quality, canUse, level, minBid, minIncrement,buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)   -- i == 1

        if buyoutPrice == nil then buyoutPrice = "" end
        if highestBidder == nil then highestBidder = "" end
        if sold == nil then sold = "" end
        if canUse == nil then canUse = "" end

        record = name .. ", " .. texture .. ", " .. count .. ", " .. quality .. ", " .. canUse .. ", " .. level .. ", " .. minBid .. ", " .. minIncrement .. ", " .. buyoutPrice .. ", " .. bidAmount .. ", " .. highestBidder .. ", " .. owner .. ", " .. sold
        print(i..":  "..record)
    end

end