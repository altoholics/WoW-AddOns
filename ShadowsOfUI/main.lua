local _, ns = ...

local ui = LibNUI
local StatusBar = ui.StatusBar
local TopLeft, TopRight, BottomLeft, BottomRight = ui.edge.TopLeft, ui.edge.TopRight, ui.edge.BottomLeft, ui.edge.BottomRight

local CreateColor = CreateColor
local UnitLevel, UnitXP, UnitXPMax, GetXPExhaustion, GetRestState = UnitLevel, UnitXP, UnitXPMax, GetXPExhaustion, GetRestState
local StatusTrackingBarManager = StatusTrackingBarManager

-- default xp bar: https://github.com/Gethe/wow-ui-source/blob/c0f3b4f1794953ba72fa3bc5cd25a6f2cdd696a1/Interface/AddOns/Blizzard_ActionBar/Mainline/ExpBar.lua

-- https://github.com/teelolws/EditModeExpanded

local function GetPlayerLevelXP()
  local level = UnitLevel("player")
  local currentXP = UnitXP("player")
  local maxXP = UnitXPMax("player")
  return level, currentXP, maxXP
end

-- CreateColor(88/255, 0, 145/255, 0)
local UnrestedGradientStart = CreateColor(88/255, 0, 145/255, 0.7)
local UnrestedGradientEnd = CreateColor(154/255, 8/255, 252/255, 0.7)
local RestedGradientStart = CreateColor(0, 32/255, 128/255, 0.7)
local RestedGradientEnd = CreateColor(0, 64/255, 1, 0.7)

local function onLoad(self)
  -- darken top edge of bar
  self:withTextureOverlay("edge", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", CreateColor(0, 0, 0, 0), CreateColor(0, 0, 0, 0.7)},
    clamp = {
      {TopLeft},
      {BottomRight, self.frame, TopRight, 0, -3}
    },
  })

  -- fade into ui above
  self:withTextureBackground("fade", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", CreateColor(0, 0, 0, 0.5), CreateColor(0, 0, 0, 0)},
    clamp = {
      {TopLeft, 0, 3},
      {BottomRight, self.frame, TopRight},
    },
  })

  -- secondary bar to show rested amount
  self:withTextureArtwork("secondary", {
    color = {RestedGradientEnd.r, RestedGradientEnd.g, RestedGradientEnd.b, 0.5},
    clamp = {
      {TopLeft, self.fill.texture, TopRight},
      {BottomRight, self.fill.texture, BottomRight}
    },
  })
end

local ExpBar = StatusBar:new{
  parent = UIParent,
  position = {
    height = 7,
    bottomLeft = {},
    bottomRight = {}
  },
  events = {"PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION", "PLAYER_UPDATE_RESTING"},
  backdrop = {0, 0, 0, 0.7},
  fill = {
    color = {1, 1, 1},
    blend = "ADD",
  },
  onLoad = onLoad,
}

function ExpBar:update()
  local _, xp, max = GetPlayerLevelXP()
  local w = self.frame:GetWidth()
  local pcnt = (xp / max)
  local s = w * pcnt
  self.fill.texture:SetWidth(s)
  -- self.fill.texture:SetWidth(self.frame:GetWidth())
  
  local exhaustionThreshold = GetXPExhaustion()
	local exhaustionStateID = GetRestState()
  local rested = 1 == exhaustionStateID
  if rested ~= self.rested then
    if rested then
      self.fill.texture:SetGradient("HORIZONTAL", RestedGradientStart, RestedGradientEnd)
    else
      self.fill.texture:SetGradient("HORIZONTAL", UnrestedGradientStart, UnrestedGradientEnd)
    end
    self.rested = rested
  end
  if rested and exhaustionThreshold > xp and exhaustionThreshold < max then
    pcnt = (exhaustionThreshold - xp) / max
    s = w * pcnt
    self.secondary.texture:SetWidth(s)
  end
  if (not rested) and self.secondary.texture:GetWidth() > 0 then
    self.secondary.texture:SetWidth(0)
  end
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
  if login or reload then
    self:initNotches()
    self:update()
  end
end
function ExpBar:PLAYER_XP_UPDATE() self:update() end
function ExpBar:PLAYER_LEVEL_UP() self:update() end
function ExpBar:UPDATE_EXHAUSTION() self:update() end
function ExpBar:PLAYER_UPDATE_RESTING() end


-- hide the default blizzard frame
local f = CreateFrame("Frame")
function f:OnEvent(event, ...)
  if self[event] then
    self[event](self, event, ...)
  end
end
f:SetScript("OnEvent", f.OnEvent)

function f:PLAYER_ENTERING_WORLD(event, login, reload)
  if login or reload then
    StatusTrackingBarManager:Hide()
  end
end
f:RegisterEvent("PLAYER_ENTERING_WORLD")

