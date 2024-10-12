local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Player = ns.wow.Player
local Frame = ui.Frame
local PlayerHUD = ns.PlayerHUD

local HUD = Class(Frame, function(self)
  self.player = PlayerHUD:new{
    parent = self,
    position = {
      center = {-120, -20},
    },
  }

  self:PLAYER_TARGET_CHANGED()
end, {
  parent = ns.wowui.UIParent,
  name = "ShadowHUD",
  position = {
    center = {},
    width = 1,
    height = 1,
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
