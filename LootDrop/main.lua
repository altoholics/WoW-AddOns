local _, ns = ...

local ui = LibNUI

local GetMoney, GetCoinTextureString = GetMoney, C_CurrencyInfo.GetCoinTextureString

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

-- PLAYER_XP_UPDATE

-- https://wowpedia.fandom.com/wiki/World_of_Warcraft_API#Container

-- @param bagSlot     number - the bag that has received the new item
-- @param iconFileId  number - the FileID of the item's icon
function Bucket:ITEM_PUSH(bagSlot, iconFileId)
end

-- https://wowpedia.fandom.com/wiki/QUEST_TURNED_IN
-- @param questID     number
-- @param xpReward    number - amount of xp rewarded, if any, 0 if character is max level
-- @param moneyReward number - amount of Money awarded, if any, in copper

-- https://wowpedia.fandom.com/wiki/World_of_Warcraft_API#Currency
-- https://wowpedia.fandom.com/wiki/PLAYER_MONEY
-- https://wowpedia.fandom.com/wiki/API_GetMoney





function Bucket:PLAYER_ENTERING_WORLD(login, reload)
  self:updateMoney()
end
