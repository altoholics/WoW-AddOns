local _, ns = ...

local ui = ns.g.ui
local Frame = ui.Frame

local HideUIPanel, ShowUIPanel, UnitExists, UnitAffectingCombat = ns.g.HideUIPanel, ns.g.ShowUIPanel, ns.g.UnitExists, ns.g.UnitAffectingCombat
local MainMenuBar, Bar2 = ns.g.MainMenuBar, ns.g.MultiBarBottomLeft

local BarControl = Frame:new{
  events = {"PLAYER_ENTERING_WORLD", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED"},
}
BarControl:hide()

function BarControl:update()
  if self.hasTarget or self.inCombat then
    for _,btn in pairs(MainMenuBar.actionButtons) do
      btn:Show()
    end
    for _,btn in pairs(Bar2.actionButtons) do
      btn:Show()
    end
  else
    for _,btn in pairs(MainMenuBar.actionButtons) do
      btn:Hide()
    end
    for _,btn in pairs(Bar2.actionButtons) do
      btn:Hide()
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
