local _, ns = ...
local Class, gsub, unpack = ns.lua.Class, ns.lua.gsub, ns.lua.unpack
local AbbreviateNumbers = ns.lua.AbbreviateNumbers
local ui = ns.ui
local StatusBar = ui.StatusBar
local Player = ns.wow.Player

local HealthBar = Class(StatusBar, function(self)
  local className = gsub(Player:GetClassName(), " ", "")
  local t = self.frame:GetStatusBarTexture()
  t:SetVertexColor(unpack(ns.Colors[className]))
  self:withLabel("level", {
    text = Player:GetLevel(),
    font = "GameFontNormalSmall",
    position = {
      topRight = {self.frame, ui.edge.TopLeft, 16, -2}
    },
    alpha = 0.8,
  })
  self:withLabel("hp", {
    text = AbbreviateNumbers(Player:GetHealth()),
    font = "GameFontHighlight",
    position = {
      bottomRight = {self.frame, ui.edge.BottomLeft, 14, 2},
    },
    alpha = 0.8,
  })
  self:withLabel("hpPcnt", {
    text = Player:GetHealthPercent(),
    font = "GameFontHighlight",
    position = {
      bottomRight = {self.hp.label, ui.edge.TopRight, -4, 2},
    },
    alpha = 0.8,
  })
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
    center = {},
    width = 30,
    height = 200,
  },
  events = {"PLAYER_LEVEL_UP"},
  unitEvents = {
    UNIT_HEALTH = {"player"},
  },
})
ns.PlayerHealthBar = HealthBar

function HealthBar:UNIT_HEALTH()
  local hp, max, pcnt = Player:GetHealthValues()
  self.frame:SetMinMaxValues(0, max)
  self:SetValue(hp)
  self.hp:Text(AbbreviateNumbers(hp))
  self.hpPcnt:Text(pcnt)
end

function HealthBar:PLAYER_LEVEL_UP()
  self.level:Text(Player:GetLevel())
end
