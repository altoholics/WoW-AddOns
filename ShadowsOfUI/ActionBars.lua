local addonName, ns = ...

local ui = ns.g.ui
local Frame = ui.Frame

local HideUIPanel, ShowUIPanel, UnitExists, UnitAffectingCombat = ns.g.HideUIPanel, ns.g.ShowUIPanel, ns.g.UnitExists, ns.g.UnitAffectingCombat
local MainMenuBar, Bar2, Bar3 = ns.g.MainMenuBar, ns.g.MultiBarBottomLeft, ns.g.MultiBarBottomRight

local BarControl = Frame:new{
  events = {"ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED"},
}
BarControl:hide()

function BarControl:ADDON_LOADED(name)
  if addonName ~= name then return end
  -- override visibility control on action bars
  MainMenuBar:HideOverride()
  Bar2:HideOverride()
end

function BarControl:update()
  local vis = self.hasTarget or self.inCombat
  if vis ~= self.vis then
    self.vis = vis
    if vis then
      MainMenuBar:ShowBase()
      Bar2:ShowBase()
      -- TODO: don't hide buttons that have an active cooldown
      -- for _,btn in pairs(MainMenuBar.actionButtons) do
      --   btn:Show()
      -- end
      -- for _,btn in pairs(Bar2.actionButtons) do
      --   btn:Show()
      -- end
    else
      MainMenuBar:HideBase()
      Bar2:HideBase()
      -- for _,btn in pairs(MainMenuBar.actionButtons) do
      --   btn:Hide()
      -- end
      -- for _,btn in pairs(Bar2.actionButtons) do
      --   btn:Hide()
      -- end
    end
  end
end

-- enter combat
function BarControl:PLAYER_REGEN_DISABLED()
  self.inCombat = true
  self:update()
end

-- leave combat
function BarControl:PLAYER_REGEN_ENABLED()
  self.inCombat = false
  self:update()
end

function BarControl:PLAYER_TARGET_CHANGED()
  self.hasTarget = UnitExists("target")
  self:update()
end

function BarControl:PLAYER_ENTERING_WORLD(login, reload)
  if login or reload then
    HideUIPanel(ns.g.BagsBar)
    HideUIPanel(ns.g.MicroMenuContainer)
    self.hasTarget = UnitExists("target")
    self.inCombat = UnitAffectingCombat("player")
    self:update()
  end
end
