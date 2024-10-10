local _, ns = ...
local Class = ns.lua.Class
local ui = ns.ui
local Frame, StatusBar = ui.Frame, ui.StatusBar
local Player = ns.wow.Player
local rgba = ns.wowui.rgba

local HealthBar = Class(StatusBar, function(self)
  local className = Player:GetClassName()
  self:Color(ns.Colors[className])
  self:withTextureOverlay("leftEdge", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"HORIZONTAL", rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0)},
    position = {
      topLeft = {},
      bottomLeft = {self.frame, ui.edge.BottomLeft},
      width = 5,
    },
  })
end, {
  backdrop = {color={0, 0, 0, 0.2}},
  orientation = "VERTICAL",
  position = {
    center = {-80, 0},
    width = 14,
    height = 150,
  },
  unitEvents = {
    UNIT_HEALTH = {"player"},
  },
})

function HealthBar:UNIT_HEALTH()
  local hp, max = Player.GetHealthValues()
  self.frame:SetMinMaxValues(0, max)
  self.frame:SetValue(hp)
end

local PowerBar = Class(StatusBar, function(self)
  self.frame:SetValue(0)
  self:withTextureOverlay("leftEdge", {
    color = {0, 0, 0, 0.5},
    position = {
      topLeft = {},
      bottomLeft = {self.frame, ui.edge.BottomLeft},
      width = 1,
    },
  })
  self:withTextureOverlay("rightEdge", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"HORIZONTAL", rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.5)},
    position = {
      topRight = {},
      bottomRight = {self.frame, ui.edge.BottomRight},
      width = 5,
    },
  })
end, {
  backdrop = {color={0, 0, 0, 0.2}},
  orientation = "VERTICAL",
  color = {1, 0, 0},
  min = 0,
  max = 1,
  position = {
    center = {-69, 0},
    width = 8,
    height = 150,
  },
  unitEvents = {
    UNIT_POWER_FREQUENT = {"player"},
  },
})

function PowerBar:UNIT_POWER_FREQUENT(a, powerType, ...)
  local power, x = UnitPower("player"), UnitPowerMax("player")
  self.frame:SetMinMaxValues(0, x)
  self.frame:SetValue(power)
end

local HUD = Class(Frame, function(self)
  self.health = HealthBar:new{parent = self}
  self.power = PowerBar:new{parent = self}

  self:PLAYER_TARGET_CHANGED()
end, {
  parent = ns.wowui.UIParent,
  position = {
    center = true,
    width = 300,
    height = 300,
  },
  events = {"PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED"},
})
ns.HUD = HUD

function HUD:PLAYER_REGEN_DISABLED()
  self.frame:SetAlpha(0.9)
end

function HUD:PLAYER_REGEN_ENABLED()
  self.frame:SetAlpha(0)
end

function HUD:PLAYER_TARGET_CHANGED()
  self.frame:SetAlpha((Player:InCombat() or Player:HasTarget()) and 0.9 or 0)
end
