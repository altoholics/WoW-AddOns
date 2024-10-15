local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Frame, Label = ui.Frame, ui.Label
local PlayerHUD = ns.PlayerHUD
local IsResting = IsResting() -- luacheck: globals IsResting

local HUD = Class(Frame, function(self)
  self.player = PlayerHUD:new{
    parent = self,
    position = {
      center = {-120, -20},
    },
  }
  self.resting = Label:new{
    parent = self,
    text = "RESTING",
    color = {0.7, 0.7, 0.7, 0.4},
    position = {
      center = {0, 40},
    },
  }
end, {
  parent = ns.wowui.UIParent,
  name = "ShadowHUD",
  strata = "BACKGROUND",
  position = {
    center = {},
    width = 1,
    height = 1,
  },
  events = {"PLAYER_UPDATE_RESTING"},
})
ns.HUD = HUD

function HUD:PLAYER_UPDATE_RESTING()
  self.resting.label:SetShown(IsResting())
end
