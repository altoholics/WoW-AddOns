local _, ns = ...
local Class = ns.lua.Class
local AbbreviateNumbers = ns.lua.AbbreviateNumbers
local ui = ns.ui
local StatusBar = ui.StatusBar
local Player = ns.wow.Player

local PowerBar = Class(StatusBar, function(self)
  if self.classId == 11 then -- druid
    self:registerEvent("UPDATE_SHAPESHIFT_FORM")
  end

  self:withLabel("value", {
    text = AbbreviateNumbers(Player:GetPower()),
    font = "GameFontHighlight",
    position = {
      bottomLeft = {self.frame, ui.edge.BottomRight, 0, -6},
    },
  })
  self:withLabel("percent", {
    text = Player:GetPowerPercent(),
    font = "GameFontHighlight",
    position = {
      bottomLeft = {self.frame, ui.edge.BottomRight, 0, 6},
    },
  })

  self:UPDATE_SHAPESHIFT_FORM()
  local power, x = Player:GetPowerValues()
  self.frame:SetMinMaxValues(0, x)
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
    center = {10, 0},
    width = 27,
    height = 188,
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
    self.frame:SetMinMaxValues(0, x)
    self:SetValue(power)
  end
end

function PowerBar:UPDATE_SHAPESHIFT_FORM()
  local _, powerKey, altR, altG, altB = Player:GetPowerType()
  local color = ns.Colors.PowerBarColor[powerKey]
  local t = self.frame:GetStatusBarTexture()
  if color then
    t:SetVertexColor(color.r, color.g, color.b)
  elseif altR then
    t:SetVertexColor(altR, altG, altB)
  end
end
