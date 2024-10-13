local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Frame = ui.Frame
local PlayerHUD = ns.PlayerHUD

local HUD = Class(Frame, function(self)
  self.player = PlayerHUD:new{
    parent = self,
    position = {
      center = {-120, -20},
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
})
ns.HUD = HUD
