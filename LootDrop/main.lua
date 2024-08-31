local _, ns = ...

local ui = LibNUI

local GetMoney, GetCoinTextureString, GetItemInfo = GetMoney, C_CurrencyInfo.GetCoinTextureString, C_Item.GetItemInfo

local Bucket = ui.Frame:new{
  parent = UIParent,
  position = {
    width = 100,
    height = 20,
    bottomRight = {-300, 30},
  },
  events = {"PLAYER_ENTERING_WORLD", "PLAYER_MONEY"},
  onLoad = function(self)
    self:makeDraggable()
    self:makeContainerDraggable()
    self:withTextureBackground("topBorder", {
      color = {0, 0, 0},
      clamp = {
        {ui.edge.TopLeft, 0, 1},
        {ui.edge.TopRight},
      },
    })
    -- self:withTextureBackground("bg", {
    --   color = {1, 1, 1},
    --   positionAll = true,
    --   gradient = {"VERTICAL", CreateColor(0, 0, 0, 0), CreateColor(0, 0, 0, 0.5)},
    --   blendMode = "BLEND",
    -- })
    self.money = self.frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    self.money:SetPoint("TOPRIGHT", -2, -2)
    self.money:SetText("")

    -- https://us.forums.blizzard.com/en/wow/t/help-me-with-lua-aniamtion/379238
    self.anim1 = self.frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    self.anim1:SetPoint("TOPRIGHT", 20, -2)

    self.fadeDelay = 5000
    self.tracking = {n=0}
  end
}

function Bucket:onUpdate(elapsed)
  if self.fadeTimer > 0 then
    self.fadeTimer = self.fadeTimer - elapsed
    if self.fadeTimer < 0 then self.fadeTimer = 0 end
    self.frame:SetAlpha(self.fadeTimer / self.fadeDelay)
  end
  if self.fadeTimer == 0 then
    self:stopUpdates()
  end
end

function Bucket:updateMoney()
  local money = GetMoney()
  local s = GetCoinTextureString(money)
  self.money:SetText(s)
  self.fadeTimer = self.fadeDelay
  self.frame:SetAlpha(1)
  self:startUpdates()
end

function Bucket:PLAYER_MONEY()
  self:updateMoney()
end

-- https://wowpedia.fandom.com/wiki/CHAT_MSG_LOOT
function Bucket:CHAT_MSG_LOOT(_, text, playerName, langName, chanName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, langID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, suppressRaidIcons)
  if playerName == playerName2 or playerName2 == "" then
    -- extract item link: https://wowpedia.fandom.com/wiki/ItemLink
    -- |cffxxxxxx|Hitem:payload|h[text]|h|r
    local x = string.find(text, "|cff")
    local e = string.find(text, "|r", x)
    if x and e then
      local itemLink = string.sub(text, x, e+1)
      if self.tracking[itemLink] then
        -- todo
      end
    end
  end
end

function Bucket:startTracking(itemName)
  local name, link, _, _, _, _, _, _, _, textureID = GetItemInfo(itemName)
  if name then
    
    -- if we weren't watching loot, start
    if self.tracking.n == 0 then
      self.frame:RegisterEvent("CHAT_MSG_LOOT")
    end
    self.tracking[link] = {name=name, textureID = textureID}
    print("Now tracking ", link)
  end
end

function Bucket:PLAYER_ENTERING_WORLD(login, reload)
  self:updateMoney()
end

SLASH_LOOTDROP1 = "/lootdrop"
SLASH_LOOTDROP2 = "/ld"

function SlashCmdList.LOOTDROP(msg)
  local _, _, cmd, args = string.find(msg, "(%w+) ?(.*)")
  if "add" == cmd then
    Bucket:startTracking(args)
  end
end
