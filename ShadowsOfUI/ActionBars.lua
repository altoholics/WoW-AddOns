local _, ns = ...

local ui = ns.g.ui
local Frame = ui.Frame

local HideUIPanel, ShowUIPanel, UnitExists, UnitAffectingCombat = ns.g.HideUIPanel, ns.g.ShowUIPanel, ns.g.UnitExists, ns.g.UnitAffectingCombat
local MainMenuBar = ns.g.MainMenuBar

local BarControl = Frame:new{
  events = {"PLAYER_ENTERING_WORLD", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED"},
}
BarControl:hide()

function BarControl:update()
  if self.hasTarget or self.inCombat then
    ShowUIPanel(MainMenuBar)
  else
    HideUIPanel(MainMenuBar)
  end
end

-- enter combat
function BarControl:PLAYER_REGEN_DISABLED()
  self.inCombat = true
end

-- leave combat
function BarControl:PLAYER_REGEN_ENABLED()
  self.inCombat = false
end

function BarControl:PLAYER_TARGET_CHANGED()
  self.hasTarget = UnitExists("target")
end

function BarControl:PLAYER_ENTERING_WORLD(login, reload)
  if login or reload then
    HideUIPanel(ns.g.BagsBar)
    HideUIPanel(ns.g.MicroMenuContainer)
    self.hasTarget = UnitExists("target")
    self.inCombat = UnitAffectingCombat("player")
    self:update()

    -- for k,v in pairs(MainMenuBar) do
    --   if type(v) ~= "function" then
    --     print(k)
    --   end
    -- end
  end
end
