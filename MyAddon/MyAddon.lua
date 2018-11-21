--[[


      Just nu fungerar det här "Konceptuelt"

      starta med '/ma scan0'
      och använd sedan '/ma scan1' för att bläddra frammåt, måste ske manuellt för automatiskt vill inte

      1, Event triggar inte som jag tycker den borde
      2, Wait värkar heller inte finnas att använda
      
      så frågan är kan man göra så att  Ma_Get_Auctions  märker om den returnar 0, dvs att AH inte är redo än

      Gör ett Flödes Diagram

      1. "Query"    QueryAuctionItems("", 0, 0, 0, 0, 0, l_Page, 0, 0)
      2. "EVENT"    Event
      3. 

]]--

Ma_Total_Items = 0
Ma_Page = 0


local function print(TEXT)
  DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT)
end

local function print_debug(TEXT)
  DEFAULT_CHAT_FRAME:AddMessage(RED_FONT_COLOR_CODE .. TEXT)
end

-- Create a Frame to setup a scriptable eventhandler
MyFrame = CreateFrame("Frame")
MyFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
MyFrame:SetScript("OnEvent", Event_AuctionUpdate)

-- Event Function
function Event_AuctionUpdate() 
  print_debug("[AUCTION_ITEM_LIST_UPDATE]")
  Ma_Get_Auctions()
end

-- Slash Menu  /ma
function MyAddon_Slash(msg)

    if not msg then
    	print("Slash is empty, try /ma scan")
    end

    msg = string.lower(msg)

    if (msg == "scan0") then
      Ma_Query_AH("0")    

    elseif (msg == "scan1") then
      Ma_Next_Page = Ma_Page + 1
      Ma_Query_AH(Ma_Next_Page)

    elseif (msg == "pages") then
      Ma_Number_of_Pages()

    elseif (msg == "view") then
      Ma_Get_Auctions()

    elseif (msg == "time") then
      My_Timer(1)

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
function Ma_Query_AH(l_Page)
  print_debug("Function Query_AH  - "..l_Page)
	QueryAuctionItems("", 0, 0, 0, 0, 0, l_Page, 0, 0)
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

function Ma_Number_of_Pages()   -- Stila upp den här
  local bos, Value = GetNumAuctionItems("list")
  print(tostring(Value))
end



function Ma_Get_Auctions()

  if GetNumAuctionItems("list") < 50 then
          print("Last Page")
  end
  for i=1, GetNumAuctionItems("list"), 1 do        

        local name, texture, count, quality, canUse, level, minBid, minIncrement,buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)   -- i == 1

        if buyoutPrice == nil then buyoutPrice = "" end
        if highestBidder == nil then highestBidder = "" end
        if sold == nil then sold = "" end
        if canUse == nil then canUse = "" end
        if owner == nil then owner = "" end

        record = name .. ", " .. texture .. ", " .. count .. ", " .. quality .. ", " .. canUse .. ", " .. level .. ", " .. minBid .. ", " .. minIncrement .. ", " .. buyoutPrice .. ", " .. bidAmount .. ", " .. highestBidder .. ", " .. owner .. ", " .. sold
        print(record)        
        
        Ma_Total_Items = Ma_Total_Items + 1             
       
        print_debug("Page: "..Ma_Page .."   i:   "..i.."   T:"..Ma_Total_Items)        

    end

    Ma_Page = Ma_Page + 1
    Ma_Next_Page = Ma_Page + 1
    Ma_Query_AH(Ma_Next_Page)
end