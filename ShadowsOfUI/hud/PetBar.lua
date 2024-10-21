local _, ns = ...
local Class, unpack = ns.lua.Class, ns.lua.unpack
local AbbreviateNumbers = ns.lua.AbbreviateNumbers
local ui = ns.ui
local StatusBar = ui.StatusBar
local Player = ns.wow.Player

local PetBar = Class(StatusBar, function(self)
  local className = Player:GetClassName()
  local t = self._widget:GetStatusBarTexture()
  t:SetVertexColor(unpack(ns.Colors[className]))

  self:withLabel("hp", {
    text = AbbreviateNumbers(Player:GetHealth()),
    font = "GameFontHighlightSmall",
    position = {
      BottomRight = {self._widget, ui.edge.BottomLeft, 7, 2},
    },
    alpha = 0.8,
  })
  self:withLabel("hpPcnt", {
    text = Player:GetHealthPercent(),
    font = "GameFontHighlightSmall",
    position = {
      BottomRight = {self.hp.label, ui.edge.TopRight, -4, 2},
    },
    alpha = 0.8,
  })
end, {
  name = "$parentPet",
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
    Center = {-14, 0},
    Width = 14,
    Height = 136,
  },
  unitEvents = {
    UNIT_HEALTH = {"pet"},
    UNIT_PET = {"player"},
  },
})
ns.PetBar = PetBar

function PetBar:UNIT_HEALTH()
  local hp, max = Player.GetPetHealthValues()
  self._widget:SetMinMaxValues(0, max)
  self:SetValue(hp)
end

function PetBar:UNIT_PET()
  self._widget:SetShown(ns.wow.UnitExists("pet"))
end
