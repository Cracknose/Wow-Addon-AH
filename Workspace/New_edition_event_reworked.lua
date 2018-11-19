local function print(TEXT)
  DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT)
end

local function print_debug(TEXT)
  DEFAULT_CHAT_FRAME:AddMessage(RED_FONT_COLOR_CODE .. TEXT)
end

MyFrame = CreateFrame("Frame")
MyFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
MyFrame:SetScript("OnEvent", Event_AuctionUpdate)


function Event_AuctionUpdate()
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
    Ma_Next_Page = Ma_Page + 1
        
       
    print_debug("Page: "..Ma_Page .."   i:   "..i.."   T:"..Ma_Total_Items)        

  end  
end

function MyAddon_Slash(msg)

    if not msg then
    	print("Slash is empty, try /ma scan")
    end

    msg = string.lower(msg)

    if (msg == "scan") then
      Ma_Query_AH()    

    elseif (msg == "pages") then
      Ma_Number_of_Pages()

    elseif (msg == "view") then
      Ma_Get_Auctions()

    elseif (msg == "time") then
      My_Timer(1)

    elseif (msg == "help") then
      print("MyAddon, AH Edition")
      print("/ma Scan  - Start AH Scan")
      print("/ma Pages - Print number of pages in AH")
      print("/ma View  - View Listing gotten from AH")
      print("/ma Time  - Not even i know what this is..")

    else
        print("Unkown Command, try /ma help")
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