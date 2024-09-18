local _, ns = ...

local ui = ns.g.ui
local min = ns.min
local StatusBar = ui.StatusBar
local TopLeft, TopRight, BottomLeft, BottomRight = ui.edge.TopLeft, ui.edge.TopRight, ui.edge.BottomLeft, ui.edge.BottomRight

local CreateColor = ns.g.CreateColor
local GetXPExhaustion, GetRestState = ns.g.GetXPExhaustion, ns.g.GetRestState

-- default xp bar: https://github.com/Gethe/wow-ui-source/blob/c0f3b4f1794953ba72fa3bc5cd25a6f2cdd696a1/Interface/AddOns/Blizzard_ActionBar/Mainline/ExpBar.lua

-- https://github.com/teelolws/EditModeExpanded

-- CreateColor(88/255, 0, 145/255, 0)
local UnrestedGradientStart = CreateColor(88/255, 0, 145/255, 0.5)
local UnrestedGradientEnd = CreateColor(154/255, 8/255, 252/255, 0.5)
local RestedGradientStart = CreateColor(0, 32/255, 128/255, 0.5)
local RestedGradientEnd = CreateColor(0, 64/255, 1, 0.5)

local function onLoad(self)
  -- darken top edge of bar
  self:withTextureOverlay("edge", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", CreateColor(0, 0, 0, 0), CreateColor(0, 0, 0, 0.5)},
    clamp = {
      {TopLeft},
      {BottomRight, self.frame, TopRight, 0, -3}
    },
  })

  -- fade into ui above
  self:withTextureBackground("fade", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", CreateColor(0, 0, 0, 0.3), CreateColor(0, 0, 0, 0)},
    clamp = {
      {TopLeft, 0, 3},
      {BottomRight, self.frame, TopRight},
    },
  })

  -- secondary bar to show rested amount
  self:withTextureArtwork("secondary", {
    color = {RestedGradientEnd.r, RestedGradientEnd.g, RestedGradientEnd.b, 0.5},
  })
  self.secondary.texture:SetHeight(self.frame:GetHeight())

  -- percent text
  self.textPercent = self.frame:CreateFontString(nil, "ARTWORK", "SystemFont_Tiny2")
  self.textPercent:SetHeight(self.frame:GetHeight() - 2)
  self.textPercent:SetTextColor(1, 1, 1, 0)

  self.restPercent = self.frame:CreateFontString(nil, "ARTWORK", "SystemFont_Tiny2")
  self.restPercent:SetHeight(self.frame:GetHeight() - 2)
  self.restPercent:SetTextColor(1, 1, 1, 0)

  -- make sure we can get mouse hover events in order to show the text
  self.fadeDelay = 500
  self.frame:SetMouseMotionEnabled(true)
  self.frame:SetScript("OnEnter", function() self:onEnter() end)
  self.frame:SetScript("OnLeave", function() self:onLeave() end)
end

local ExpBar = StatusBar:new{
  parent = ns.g.UIParent,
  position = {
    height = 7,
    bottomLeft = {},
    bottomRight = {}
  },
  events = {"PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION", "PLAYER_UPDATE_RESTING"},
  backdrop = {0, 0, 0, 0.3},
  fill = {
    color = {1, 1, 1},
    blend = "ADD",
    gradient = {"HORIZONTAL", UnrestedGradientStart, UnrestedGradientEnd},
  },
  onLoad = onLoad,
}

function ExpBar:onUpdate(elapsed)
  if self.fadeTimer > 0 then
    self.fadeTimer = self.fadeTimer - elapsed
    if self.fadeTimer < 0 then self.fadeTimer = 0 end
    self.textPercent:SetTextColor(1, 1, 1, self.fadeTimer / self.fadeDelay)
    self.restPercent:SetTextColor(1, 1, 1, self.fadeTimer / self.fadeDelay)
  end
  if self.fadeTimer == 0 then
    self:stopUpdates()
  end
end

-- mouse enters bar region
function ExpBar:onEnter()
  self.textPercent:SetTextColor(1, 1, 1, 1)
  self.restPercent:SetTextColor(1, 1, 1, 1)
end

-- mouse leaves bar region
function ExpBar:onLeave()
  self.fadeTimer = self.fadeDelay
  self:startUpdates()
end

function ExpBar:update()
  local xp, max = ns.GetPlayerLevelXP()
  local w = self.frame:GetWidth()
  local pcnt = (xp / max)
  local s = w * pcnt
  self.fill.texture:SetWidth(s)
  self.textPercent:SetPoint(TopRight, self.frame, TopLeft, s - 3, -1)
  self.textPercent:SetText(floor(pcnt * 100).."%")

  local exhaustionThreshold = GetXPExhaustion()
	local exhaustionStateID = GetRestState()
  local rested = 1 == exhaustionStateID
  local bonus = ""
  if rested and exhaustionThreshold > xp then
    bonus = exhaustionThreshold > max and "+" or ""
    pcnt = (min(exhaustionThreshold, max) - xp) / max
    s = w * pcnt
    self.secondary.texture:SetWidth(s)
  else
    pcnt = 0
    s = 0
  end
  if (not rested) and self.secondary.texture:GetWidth() > 0 then
    self.secondary.texture:SetWidth(0)
  end
  self.secondary.texture:SetPoint(TopLeft, self.fill.texture:GetWidth(), 0)
  self.restPercent:SetPoint(TopLeft, self.frame, TopLeft, self.fill.texture:GetWidth() + 3, -1)
  self.restPercent:SetText(floor(pcnt * 100)..bonus.."%")
end

function ExpBar:initNotches()
  -- add the little notches every 10%
  local spacing = self.frame:GetWidth() / 10
  for i=1,9 do
    self:withTextureOverlay("notch"..i, {
      color = {1, 1, 1},
      blendMode = "BLEND",
      gradient = {"HORIZONTAL", CreateColor(0, 0, 0, 0.3), CreateColor(0, 0, 0, 0.2)},
      clamp = {
        {TopLeft, spacing * i, 0},
        {BottomRight, self.frame, BottomLeft, spacing * i + 3, 0},
      },
    })
  end
end

function ExpBar:PLAYER_ENTERING_WORLD(login, reload)
  -- hide the default blizzard frame
  if login or reload then
    ns.g.StatusTrackingBarManager:Hide()
  end
  -- if player at max level, hide bar
  local level = ns.g.UnitLevel("player")
  if level == ns.g.maxLevel then
    self:hide()
    return
  end
  -- register for other events
  if login or reload then
    self:initNotches()
    self:update()
  end
end
function ExpBar:PLAYER_XP_UPDATE() self:update() end
function ExpBar:PLAYER_LEVEL_UP() self:update() end
function ExpBar:UPDATE_EXHAUSTION() self:update() end
function ExpBar:PLAYER_UPDATE_RESTING() self:update() end

