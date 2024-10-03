local _, ns = ...

local ui = ns.ui
local StatusBar = ui.StatusBar
local TopLeft, TopRight = ui.edge.TopLeft, ui.edge.TopRight
local BottomLeft, BottomRight = ui.edge.BottomLeft, ui.edge.BottomRight
local rgba = ns.wowui.rgba

-- https://github.com/teelolws/EditModeExpanded

-- CreateColor(88/255, 0, 145/255, 0)
local UnrestedGradientStart = rgba(88, 0, 145, 0.5)
local UnrestedGradientEnd = rgba(154, 8, 252, 0.5)
local RestedGradientStart = rgba(0, 32, 128, 0.5)
local RestedGradientEnd = rgba(0, 64, 255, 0.5)

local function onLoad(self)
  -- darken top edge of bar
  self:withTextureOverlay("edge", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.5)},
    clamp = {
      {TopLeft},
      {BottomRight, self.frame, TopRight, 0, -3}
    },
  })

  -- fade into ui above
  self:withTextureBackground("fade", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0)},
    clamp = {
      {TopLeft, 0, 3},
      {BottomRight, self.frame, TopRight},
    },
  })

  -- secondary bar to show rested amount
  self:withTextureArtwork("secondary", {
    color = {0, 64/255, 1, 0.5},
  })
  self.secondary.texture:SetHeight(self.frame:GetHeight())
  self.secondary.texture:SetGradient("HORIZONTAL", RestedGradientStart, RestedGradientEnd)

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
  parent = ns.wowui.UIParent,
  position = {
    height = 7,
    bottomLeft = {},
    bottomRight = {}
  },
  events = {
    "PLAYER_ENTERING_WORLD", "PLAYER_XP_UPDATE", "PLAYER_LEVEL_UP", "UPDATE_EXHAUSTION", "PLAYER_UPDATE_RESTING"
  },
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
  local xp = ns.wow.Player.getXPPercent()
  self.fill.texture:SetWidth(xp)
  self.textPercent:SetPoint(TopRight, self.frame, TopLeft, xp - 3, -1)
  self.textPercent:SetText(ns.lua.floor(xp * 100).."%")

  local rest = ns.wow.Player.getRestPercent()
  self.secondary.texture:SetWidth(rest)
  self.secondary.texture:SetPoint(TopLeft, self.fill.texture:GetWidth(), 0)
  self.restPercent:SetPoint(TopLeft, self.frame, TopLeft, self.fill.texture:GetWidth() + 3, -1)
  self.restPercent:SetText(ns.lua.floor(rest * 100).."%")
end

function ExpBar:initNotches()
  -- add the little notches every 10%
  local spacing = self.frame:GetWidth() / 10
  for i=1,9 do
    self:withTextureOverlay("notch"..i, {
      color = {1, 1, 1},
      blendMode = "BLEND",
      gradient = {"HORIZONTAL", rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.2)},
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
    ns.wowui.StatusTrackingBarManager:Hide()
  end
  -- if player at max level, hide bar
  if ns.wow.Player.isMaxLevel() then
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

