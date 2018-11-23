--[[
    TEST ADDON FOR DEVELOPMENT AND TESTING
    
    Här ska jag testa fram En Wait function och threading

    * Gjorde om alla Functions till Locals om det nu gör ngt felaktigt
    * Kolla upp AddMessage color schemes
    * Kolla på att printa text i ett GUI ist för i chatten


    local waitTable = {}; 
    local waitFrame = nil;  
    function <PREFIX>__wait(delay, func, ...)   
       if(type(delay)~="number" or type(func)~="function") then     
         return false;   
       end   
       if(waitFrame == nil) then     
         waitFrame = CreateFrame("Frame","WaitFrame", UIParent);     
         waitFrame:SetScript("onUpdate",function (self,elapse)       
         local count = #waitTable;       
         local i = 1;       
         while(i<=count) do         
           local waitRecord = tremove(waitTable,i);         
           local d = tremove(waitRecord,1);         
           local f = tremove(waitRecord,1);         
           local p = tremove(waitRecord,1);         
           if(d>elapse) then           
             tinsert(waitTable,i,{d-elapse,f,p});           
             i = i + 1;         
           else           
             count = count - 1;           
             f(unpack(p));         
           end        
         end
       end);    
      end   
tinsert(waitTable,{delay,func,{...}});   
return true; end 

]]--

Test_Debugging_Enabled = 1
Test_Debug_DataTable = {}

local function Debug_Print(Msg)
  DEFAULT_CHAT_FRAME:AddMessage(BLUE_FONT_COLOR_CODE .. Msg)
end

local function Debug_Log(Msg)
  list.append(Test_Debug_DataTable, Msg)
end

local function print(Msg)
  DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. Msg)
end


-- Slash Menu  /ma
local function Slash(Msg)

    if not Msg then
    	print("Slash is empty, try /Ta")
    end

    Msg = string.lower(Msg)

    if (Msg == "1") then
  

    elseif (Msg == "2") then
     

    elseif (Msg == "3") then
     

    else
        print("Slash Error")
    end
end


-- Onload Function, Runs automaticly on load.  (Needs an xml file to work)
-- Binds slash commands to the addon  [ /ma ]
local function Test_Addon_OnLoad()
	print("[TEST-ADDON]: Loaded")
	SlashCmdList["TEST-ADDON"] = Slash;
	SLASH_MYADDON1 = "/TestAddon";
	SLASH_MYADDON2 = "/Ta";
end


local function Ta_WaitTime(T0)
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
