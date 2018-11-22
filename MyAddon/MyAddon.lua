--[[

    +++++
      Just nu fungerar det här "Konceptuelt"
      starta med '/ma scan0'
      och använd sedan '/ma scan1' för att bläddra frammåt, måste ske manuellt för automatiskt vill inte
      1, Event triggar inte som jag tycker den borde
      2, Wait värkar heller inte finnas att använda
      
      så frågan är kan man göra så att  Ma_Get_Auctions  märker om den returnar 0, dvs att AH inte är redo än
      

    ++++++
      Gör ett Flödes Diagram

      1. "Query"      QueryAuctionItems("", 0, 0, 0, 0, 0, l_Page, 0, 0)
      2. "EVENT"      Event
      3. "Read loop"  GetAuctionItemInfo("list", i)
      ---------------
      . Reapeat

    ++++++
      Just nu så har jag last det till punkten att Resultatet uppnåss (GRATTIS)
      MEN det är halvautomatiskt, jag måste trycka igång ett macro varje 6-8s sekund för uppdatering

      Fixa en Eventhandler som kan hantera flertal events

      !! Kommentera !! Kommentera !! Kommentera !! Kommentera !!

      allting funkar nu egentligen fast ibland hinner inte Eventet och AH refresh att synca
      jag kollade lite i Aux adonnet och där används:
          thread(when, later(5), send_signal)
          thread(when, later(5), send_signal)


      Kolla upp Thread


      

]]--

Ma_Total_Items = 0
Ma_Page = 0
Ma_datatable={}
Ma_TableCount = 1
-- Timer Variabler
Ma_AuctionPagesBeforWait = 2
Ma_TImer = 1


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
  print("[AUCTION_ITEM_LIST_UPDATE]")
  
  Ma_AuctionPagesBeforWait = Ma_AuctionPagesBeforWait - 1
  if Ma_AuctionPagesBeforWait == 0 then 
    Ma_AuctionPagesBeforWait = 2
    Ma_WaitTime(Ma_TImer) 
  end
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
      Ma_PrintTable()

    elseif (msg == "time") then
      Ma_WaitTime(Ma_TImer)

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
    		--[[ "name", 	minLevel, maxLevel, invTypeIndex, classIndex, subclassIndex, 	page, 	isUsable, 	qualityIndex,		]]--
end

function Ma_Number_of_Pages()   -- Stila upp den här
  local bos, Value = GetNumAuctionItems("list")
  print(tostring(Value))
end

function Ma_PrintTable()
  print_debug("-- Printing Table --")
    for table, data in pairs(Ma_datatable) do
      print(data)
    end

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

        record = Ma_TableCount .. ", " ..name .. ", " .. texture .. ", " .. count .. ", " .. quality .. ", " .. canUse .. ", " .. level .. ", " .. minBid .. ", " .. minIncrement .. ", " .. buyoutPrice .. ", " .. bidAmount .. ", " .. highestBidder .. ", " .. owner .. ", " .. sold
       -- print(record)        
       
       Ma_TableCount = Ma_TableCount + 1
       table.insert(Ma_datatable,record)
        
        Ma_Total_Items = Ma_Total_Items + 1             
       
        

    end

    print_debug("Page: "..Ma_Page .."   T:"..Ma_Total_Items)  

    Ma_Page = Ma_Page + 1
    Ma_Next_Page = Ma_Page + 1
    Ma_Query_AH(Ma_Next_Page)
    
    

    
end

function Ma_WaitTime(T0)
  local Time = GetTime()
  Time = math.floor(Time)

  local TimeCheck = Time + T0

  print("Time: " .. Time .. ",  Check:  " .. TimeCheck)

  while TimeCheck > Time do
    Time = GetTime()
    -- print(math.floor(GetTime()))
  end
  print("Done")

end