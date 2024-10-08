local ADDON_NAME, ns = ...

local ui = LibNUI

local GetMoney, GetCoinTextureString, GetItemInfo = GetMoney, C_CurrencyInfo.GetCoinTextureString, C_Item.GetItemInfo

local function max(a, b)
  return a > b and a or b
end

local Bucket = ui.Frame:new{
  parent = UIParent,
  position = {
    width = 100,
    height = 20,
    bottomRight = {-300, 30},
  },
  events = {"PLAYER_ENTERING_WORLD", "PLAYER_MONEY", "ADDON_LOADED"},
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
    self.money = self.frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    self.money:SetPoint("TOPRIGHT", -2, -2)
    self.money:SetText("")

    -- https://us.forums.blizzard.com/en/wow/t/help-me-with-lua-aniamtion/379238
    self.anim1 = self.frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    self.anim1:SetPoint("TOPRIGHT", 20, -2)

    self.fadeDelay = 10000
    self.fadeDuration = 5000
    self.tracking = {n=0}
  end
}

function Bucket:checkSize()
  local w = max(100, self.money:GetUnboundedStringWidth())
  self.frame:SetWidth(w + 4)
end

function Bucket:onUpdate(elapsed)
  if self.fadeWait > 0 then
    self.fadeWait = self.fadeWait - elapsed
    if self.fadeWait <= 0 then
      self.fadeWait = -1
      self.fadeTimer = self.fadeDuration
    end
  end
  if self.fadeTimer > 0 then
    self.fadeTimer = self.fadeTimer - elapsed
    if self.fadeTimer <= 0 then
      self:stopUpdates()
      self.fadeTimer = -1
      self.frame:SetAlpha(0)
    else
      self.frame:SetAlpha(self.fadeTimer / self.fadeDuration)
    end
  end
end

function Bucket:updateMoney()
  local money = GetMoney()
  local s = GetCoinTextureString(money)
  self.money:SetText(s)
  -- reset timers
  self.fadeTimer = -1
  self.fadeWait = self.fadeDelay
  self.frame:SetAlpha(1)
  self:checkSize()
  self:startUpdates()
end

function Bucket:PLAYER_MONEY()
  self:updateMoney()
end

-- https://wowpedia.fandom.com/wiki/CHAT_MSG_LOOT
function Bucket:CHAT_MSG_LOOT(text, playerName, langName, chanName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, langID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, suppressRaidIcons)
  if playerName == playerName2 or playerName2 == "" then -- our loot
    -- extract item link: https://wowpedia.fandom.com/wiki/ItemLink
    -- |cffxxxxxx|Hitem:payload|h[text]|h|r
    local x = string.find(text, "|cff")
    local e = string.find(text, "|r", x)
    if x and e then
      local itemLink = string.sub(text, x, e+1)
      if self.db.trackedItems[itemLink] then
        -- todo
      end
    end
  end
end

local defaults = {trackedItems = {n=0}}
function Bucket:ADDON_LOADED(name)
  if ADDON_NAME == name then
    self.db = LootDropDB or CopyTable(defaults)
  end
end

function Bucket:startTracking(itemName)
  local name, link, _, _, _, _, _, _, _, textureID = GetItemInfo(itemName)
  if name and not self.db.trackedItems[link] then
    -- if we weren't watching loot, start
    if self.db.trackedItems.n == 0 then
      self.frame:RegisterEvent("CHAT_MSG_LOOT")
    end
    self.db.trackedItems.n = self.db.trackedItems.n + 1
    self.db.trackedItems[link] = {name=name, textureID = textureID}
    print("Now tracking ", link)
  end
end

function Bucket:stopTracking(itemName)
  local name, link, _, _, _, _, _, _, _, textureID = GetItemInfo(itemName)
  if name and self.db.trackedItems[link] then
    self.db.trackedItems.n = self.db.trackedItems.n - 1
    self.db.trackedItems[link] = nil
    print("No longer tracking ", link)
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
  elseif "remove" == cmd then
    Bucket:stopTracking(args)
  end
end
