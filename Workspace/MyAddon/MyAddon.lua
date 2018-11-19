

-- Pre Load Variables
Page = 0

local function print(TEXT)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT);
end



-- Skapa en Frame som fångar events
MyFrame = CreateFrame("Frame")
MyFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
MyFrame:SetScript("OnEvent", Event_AuctionUpdate)
-- Slut på Frame som fångar events


local function Event_AuctionUpdate(e)
	-- scan
end

-- /addon chat commando
-- Behöver en OnLoad Funktion för att funka och den i sin tur behöver en XMl fil för att fungera
function MyAddon_Slash(msg)

    if not msg then
    	print("Slash is empty, try /ma scan")
    end

    msg = string.lower(msg)

    -- Olika Test värden i chat kommando Funktionen
    if (msg == "scan0") then
        Query_AH(0)    

    elseif (msg == "scan1") then
      Query_AH(1)

    elseif (msg == "view") then
      Get_Auctions()

    elseif (msg == "time") then
      My_Timer(1)

    else
        print("Slash Error")
    end
end


-- Function som körs automatiskt OnLoad  (behöver en xml fil för att funka)
-- Bindar Slash commandon till addonen
function MyAddon_OnLoad()
	print("[MyAddon]: Loaded")
	SlashCmdList["MYADDON"] = MyAddon_Slash;
	SLASH_MYADDON1 = "/MyAddon";
	SLASH_MYADDON2 = "/ma";
end


local function Query_AH(Page)
  print("Fcuntion Query_AH")
	QueryAuctionItems("", 0, 0, 0, 0, 0, Page, 0, 0)
    		--[[
				"name", 
				minLevel, 
				maxLevel, 
  				invTypeIndex, 
  				classIndex, 
  				subclassIndex, 
  				page, 
  				isUsable, 
  				qualityIndex,
    		]]--

end

local function Number_of_Pages()
  local Value = GetNumAuctionItems("list")
  return Value
end


local function Get_Auctions()
  for i=1, GetNumAuctionItems("list"), 1 do

      --[[    Printar ut en ItemLink
      local link = GetAuctionItemLink("list", i)
      if link then
        print("link: "..link)
      end
      ]]--

        local name, texture, count, quality, canUse, level, minBid, minIncrement,buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)   -- i == 1

        if buyoutPrice == nil then buyoutPrice = "" end
        if highestBidder == nil then highestBidder = "" end
        if sold == nil then sold = "" end
        if canUse == nil then canUse = "" end
        if owner == nil then owner = "" end

        record = name .. ", " .. texture .. ", " .. count .. ", " .. quality .. ", " .. canUse .. ", " .. level .. ", " .. minBid .. ", " .. minIncrement .. ", " .. buyoutPrice .. ", " .. bidAmount .. ", " .. highestBidder .. ", " .. owner .. ", " .. sold
        print(i..":  "..record)
        -- Skapa en List och lägg till Record i den
    end
end