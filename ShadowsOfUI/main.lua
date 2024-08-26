local _, ns = ...

local ui = LibNUI
local StatusBar = ui.StatusBar
local TopLeft, TopRight, BottomLeft, BottomRight = ui.edge.TopLeft, ui.edge.TopRight, ui.edge.BottomLeft, ui.edge.BottomRight

local CreateColor, ReloadUI = CreateColor, ReloadUI
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

local function onLoad(self)
  self.rested = false

  self:withTextureOverlay("edge", {color = {1, 1, 1}})
  self.edge.texture:SetPoint(TopLeft)
  self.edge.texture:SetPoint(BottomRight, self.frame, TopRight, 0, -4)
  self.edge.texture:SetGradient("VERTICAL", CreateColor(0, 0, 0, 0), CreateColor(0, 0, 0, 1))
  self.edge.texture:SetBlendMode("BLEND")

  self:withTextureBackground("fade", {color = {1, 1, 1}})
  self.fade.texture:SetPoint(TopLeft, 0, 4)
  self.fade.texture:SetPoint(BottomRight, self.frame, TopRight)
  self.fade.texture:SetGradient("VERTICAL", CreateColor(0, 0, 0, 0.5), CreateColor(0, 0, 0, 0))
  self.fade.texture:SetBlendMode("BLEND")

  self:withTextureOverlay("notch1", {color = {1, 1, 1}})
  self.notch1.texture:SetPoint(TopLeft, self.frame:GetWidth() / 10, 0)
  self.notch1.texture:SetPoint(BottomRight, self.frame, BottomLeft, (self.frame:GetWidth() / 10) + 5, 0)
  self.notch1.texture:SetGradient("HORIZONTAL", CreateColor(0, 0, 0, 0.5), CreateColor(0, 0, 0, 0))
  self.notch1.texture:SetBlendMode("BLEND")
end

-- CreateColor(88/255, 0, 145/255, 0)
local UnrestedGradientStart = CreateColor(88/255, 0, 145/255, 0.8)
local UnrestedGradientEnd = CreateColor(154/255, 8/255, 252/255, 0.8)
local RestedGradientStart = CreateColor(0, 32/255, 128/255, 0.8)
local RestedGradientEnd = CreateColor(0, 64/255, 1, 0.8)
local ExpBar = StatusBar:new{
  parent = UIParent,
  position = {
    height = 11,
    bottomLeft = {},
    bottomRight = {}
  },
  events = {"PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION", "PLAYER_UPDATE_RESTING"},
  backdrop = {0, 0, 0, 0.8},
  fill = {
    color = {1, 1, 1},
    blend = "ADD",
  },
  onLoad = onLoad,
}

function ExpBar:update()
  local _, xp, max = GetPlayerLevelXP()
  local w = self.frame:GetWidth()
  local pcnt = (xp / max) * 100
  local s = w / pcnt
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
end

function ExpBar:PLAYER_ENTERING_WORLD() self:update() end
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

