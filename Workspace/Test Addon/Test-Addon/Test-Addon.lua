--[[
    TEST ADDON FOR DEVELOPMENT AND TESTING
    
    Här ska jag testa fram En Wait function och threading
      

]]--




local function print(TEXT)
  DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. TEXT)
end


-- Slash Menu  /ma
function Slash(msg)

    if not msg then
    	print("Slash is empty, try /ma scan")
    end

    msg = string.lower(msg)

    if (msg == "1") then
  

    elseif (msg == "2") then
     

    elseif (msg == "3") then
     

    else
        print("Slash Error")
    end
end


-- Onload Function, Runs automaticly on load.  (Needs an xml file to work)
-- Binds slash commands to the addon  [ /ma ]
function Test_Addon_OnLoad()
	print("[TEST-ADDON]: Loaded")
	SlashCmdList["TEST-ADDON"] = Slash;
	SLASH_MYADDON1 = "/TestAddon";
	SLASH_MYADDON2 = "/Ta";
end


function Ta_WaitTime(T0)
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