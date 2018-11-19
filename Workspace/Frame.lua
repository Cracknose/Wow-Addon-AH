-- Name        : AucSum
-- Version     : v1.2
-- Create Date : 21-1-2017

AucSum_UpdateInterval = 0.1;

function AucSum_OnEvent(self, elapsed)

  local _G = _G

  if event == "ADDON_LOADED" and arg1 == "AucSum" then
    if formatSimple == nil or formatSimple == true then
      formatSimple = true
      _G["formatSimple"] = true;
    else 
      formatSimple = false
      _G["formatSimple"] = false;
    end
  end

  SLASH_AUCSUM1, SLASH_AUCSUM2 = '/as', '/aucsum'; 
  local function handler(msg, editbox)
    if msg == 'simple' then
      print("You have enabled the simple format.\nx Auctions (xK Gold)");
       _G["formatSimple"] = true;
      formatSimple = true;
    elseif msg == 'extended' then 
      print("You have enabled the extended format.\nx Auctions, Total Worth:\nx Gold, x Silver and x Copper");
      _G["formatSimple"] = false;
      formatSimple = false;
    else
      print("AucSum: Arguments to /as\n simple - Enable simple text format\n extended - Enable extended text format")
    end
  end
  SlashCmdList["AUCSUM"] = handler; 


  if IsResting() then

    self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;

    if (self.TimeSinceLastUpdate > AucSum_UpdateInterval) then

      if AuctionFrame ~= nil then
        if AuctionFrame:IsVisible() == true then
          if AuctionsScrollFrame:IsVisible() == true then
            if AuctionsSearchCountText:IsVisible() == true then
              if not string.match(AuctionsSearchCountText:GetText(), "Total") then
                local total = 0;
                local i = 1;
                local batch,count = GetNumAuctionItems("owner");

                for var = 0, count, 1 do
                  local name, texture, count, quality, canUse, level, levelColHeader, minBid, minIncrement,
                  buyoutPrice, bidAmount, highBidder, highBidderFullName, owner, ownerFullName,
                  saleStatus, itemId, hasAllInfo = GetAuctionItemInfo("owner", var);
                  local gold = buyoutPrice / 100
                  total = total + gold;
                end

                local copper = total %  100;
                local silver = ( total / 100 ) % 100;
                local gold = (total / 100);

                if _G["formatSimple"] == false then
                  AuctionsSearchCountText:SetText(count .. " Auctions, Total worth:\n" .. comma_value(math.floor(gold, 2)) .. " Gold, " .. math.floor(silver,2) .. " Silver and " .. math.floor(copper, 2) .. " Copper" );
                else
                  local find = string.sub(string.find(comma_value(math.floor(gold, 2)), ","), 1) - 1
                  if find then
                    AuctionsSearchCountText:SetText(count .. " Auctions (" .. string.sub(comma_value(math.ceil(gold, 2)), 0, find) .. "K Gold)");
                  else
                    AuctionsSearchCountText:SetText(count .. " Auctions (" .. comma_value(math.ceil(gold, 2)) .. "K Gold)");
                  end
                end  
              end
            end
          end
        end
      end
      self.TimeSinceLastUpdate = 0;
    end
  end
end

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

function AucSum_OnLoad()
  AucSumFrame:Hide();
  AucSumFrame:RegisterAllEvents();
end