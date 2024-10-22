local _, ns = ...
local Class = ns.lua.Class
local AbbreviateNumbers = ns.lua.AbbreviateNumbers
local ui = ns.ui
local StatusBar, Label = ui.StatusBar, ui.Label
local Player = ns.wow.Player

local PowerBar = Class(StatusBar, function(self)
  if self.classId == 11 then -- druid
    self:registerEvent("UPDATE_SHAPESHIFT_FORM")
  end

  self.value = Label:new{
    parent = self,
    text = AbbreviateNumbers(Player:GetPower()),
    font = "GameFontHighlight",
    position = {
      BottomLeft = {self, ui.edge.BottomRight, 0, -6},
    },
    alpha = 0.8,
  }
  self.percent = Label:new{
    parent = self,
    text = Player:GetPowerPercent(),
    font = "GameFontHighlight",
    position = {
      BottomLeft = {self, ui.edge.BottomRight, 0, 6},
    },
    alpha = 0.8,
  }

  self:UPDATE_SHAPESHIFT_FORM()
  local power, x = Player:GetPowerValues()
  self._widget:SetMinMaxValues(0, x)
  self:SetValue(power)
end, {
  name = "$parentPower",
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
    Center = {10, 0},
    Width = 27,
    Height = 188,
  },
  unitEvents = {
    UNIT_POWER_FREQUENT = {"player"},
  },
})
ns.PlayerPowerBar = PowerBar

-- https://wowpedia.fandom.com/wiki/API_UnitPowerType
function PowerBar:UNIT_POWER_FREQUENT(_, powerType, ...)
  if powerType == "MANA" or powerType == "RAGE" or powerType == "FOCUS" or powerType == "ENERGY" or powerType == "CHI"
  or powerType == "INSANITY" or powerType == "FURY" or powerType == "PAIN" or powerType == "RUNIC_POWER" then
    local power, x = Player:GetPowerValues()
    self._widget:SetMinMaxValues(0, x)
    self:SetValue(power)
  end
end

function PowerBar:UPDATE_SHAPESHIFT_FORM()
  local _, powerKey, altR, altG, altB = Player:GetPowerType()
  local color = ns.Colors.PowerBarColor[powerKey]
  local t = self._widget:GetStatusBarTexture()
  if color then
    t:SetVertexColor(color.r, color.g, color.b)
  elseif altR then
    t:SetVertexColor(altR, altG, altB)
  end
end
