--[[

	Använd Local variables
	jag tror jag börjar ha allt jag behöver för att klipp&klistra ihop något
	kolla igenom forumet 
		http://wowprogramming.com/forums/development/


	måste lära mig Global Local och fuckwhatnot
	Dags att Skissa ner det här på papper i ett flow chart




	Steg:

		1.
			Är AH öppe och sökbar?

		2. 
			Run:  QueryAuctionItems("", 0, 0, 0, 0, 0, Page, 0, 0)

		3. 
			AUCTION_ITEM_LIST_UPDATE kommer fire'as när AH-kön uppdateras
			   --> GetAuctionItemInfo

		4.	### GetAuctionItemInfo("list", i) ###
			local name, texture, count, quality, canUse, level, minBid, minIncrement,buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)

			(allmän fråga) hur hanterar jag resultat på bästa sätt?  (vi säger table)

			IF results, add to table    $Page = +1

		

]]--

Page = 0


local function print(TEXT)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT);
end


MyFrame = CreateFrame("Frame")
MyFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
MyFrame:SetScript("OnEvent", Event_AuctionUpdate)


function Event_AuctionUpdate(e)
	print("[AUCTION_ITEM_LIST_UPDATE] - Fired 'OnEvent'")
end




function MyAddon_Slash(msg)

    if not msg then
    	print("Slash is empty, try /ma scan")
    end

    msg = string.lower(msg)

    if (msg == "scan") then
        Start_Scan()

    elseif (msg == "time") then
    	My_Timer(1)

    else
        print("Slash Error")
    end
end


-- Function som körs automatiskt OnLoad  (behöver en xml fil för att funka)
-- Bindar Slash commandon till addonen
function MyAddon_OnLoad()
	print("FUCKING LOADED")
	SlashCmdList["MYADDON"] = MyAddon_Slash;
	SLASH_MYADDON1 = "/MyAddon";
	SLASH_MYADDON2 = "/ma";
end



function MyScanner()


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

    C_Timer.After(1, function() machmod = 1 end)

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

-- ###############
-- ###############
-- ###############

function total_pages(Total_Auctions)
	return math.ceil(total_auctions / Page_Size)  --Page_Size == 50
end


function Start_Scan(Page)
	Page = Page or 0
    --local Query = QueryAuctionItems("", 0, 0, 0, 0, 0, Page, 0, 0)
    QueryAuctionItems("", 0, 0, 0, 0, 0, Page, 0, 0)

    Total_Pages, Total_Auctions = GetNumAuctionItems("list");

    --My_Timer(1)

    Scan_Page(Query, 0)
   

end

--function Scan_Page(Query, Page)
function Scan_Page(Page)
	print("Starting Scan..".. tostring(Page))

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
    print("Debug - [Scan_Page]  -  Page:"..tostring(Page))
    Page = Page + 1
    Start_Scan(Page)

end

function My_Timer(s)
	-- få ett första Base tid värde
	Time_Baseline = GetTime()
	Time_Baseline = math.ceil(Time_Baseline)

	Time_Check = Time_Baseline + s

	while Time_Baseline < Time_Check do
		Time_Baseline = GetTime()
		Time_Baseline = math.ceil(Time_Baseline)		
	end
	print("Timer Done")
	return true  --testa return false härnäst




	-- While loop tills Skillnaden mellan Base_tid och Tid är mindre än S
	-- kolla upp luas int.roof
end
