local _, ns = ...
local Class, gsub, unpack = ns.lua.Class, ns.lua.gsub, ns.lua.unpack
local AbbreviateNumbers = ns.lua.AbbreviateNumbers
local ui = ns.ui
local StatusBar, Label = ui.StatusBar, ui.Label
local Player = ns.wow.Player

local HealthBar = Class(StatusBar, function(self)
  local className = gsub(Player:GetClassName(), " ", "")
  local t = self._widget:GetStatusBarTexture()
  t:SetVertexColor(unpack(ns.Colors[className]))
  self.level = Label:new{
    parent = self,
    text = Player:GetLevel(),
    font = "GameFontNormalSmall",
    position = {
      TopRight = {self, ui.edge.TopLeft, 16, -2}
    },
    alpha = 0.8,
  }
  self.hp = Label:new{
    parent = self,
    text = AbbreviateNumbers(Player:GetHealth()),
    font = "GameFontHighlight",
    position = {
      BottomRight = {self, ui.edge.BottomLeft, 14, 2},
    },
    alpha = 0.8,
  }
  self.hpPcnt = Label:new{
    parent = self,
    text = Player:GetHealthPercent(),
    font = "GameFontHighlight",
    position = {
      BottomRight = {self.hp, ui.edge.TopRight, -4, 2},
    },
    alpha = 0.8,
  }
end, {
  name = "$parentHealth",
  alpha = 0.8,
  backdrop = {
    color = false,
    path = "interface/addons/ShadowsOfUI/art/CleanCurvesBG",
    coords = {0.32, 0.05, 0.01, 0.99},
  },
  orientation = "VERTICAL",
  texture = {
    path = "interface/addons/ShadowsOfUI/art/CleanCurves",
    coords = {0.32, 0.05, 0.01, 0.99},
  },
  position = {
    Center = {},
    Width = 30,
    Height = 200,
  },
  events = {"PLAYER_LEVEL_UP"},
  unitEvents = {
    UNIT_HEALTH = {"player"},
  },
})
ns.PlayerHealthBar = HealthBar

function HealthBar:UNIT_HEALTH()
  local hp, max, pcnt = Player:GetHealthValues()
  self._widget:SetMinMaxValues(0, max)
  self:SetValue(hp)
  self.hp:Text(AbbreviateNumbers(hp))
  self.hpPcnt:Text(pcnt)
end

function HealthBar:PLAYER_LEVEL_UP(level)
  self.level:Text(level)
end
