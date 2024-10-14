local _, ns = ...
local Class = ns.lua.Class

-- for showing "clock-like" sweep and leading-edge effects
-- https://wowpedia.fandom.com/wiki/UIOBJECT_Cooldown

-- if EditModeManagerFrame then
--   EventRegistry:RegisterCallback("EditMode.Enter", function() self:Unlock(true) end)
--   EventRegistry:RegisterCallback("EditMode.Exit", function() self:Lock() end)

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_ActionBar/Mainline/ActionButton.lua

local ActionBars = Class(nil, function(self)
  self.utility = ns.UtilityBar:new{}
  self.utility2 = ns.UtilityBar2:new{}
end)
ns.ActionBars = ActionBars

-- function BarControl:update()
--   local vis = self.hasTarget or self.inCombat
--   if vis ~= self.vis then
--     self.vis = vis
--     if vis then
--       MainMenuBar:ShowBase()
--       Bar2:ShowBase()
--       -- TODO: don't hide buttons that have an active cooldown
--       -- for _,btn in pairs(MainMenuBar.actionButtons) do
--       --   btn:Show()
--       -- end
--       -- for _,btn in pairs(Bar2.actionButtons) do
--       --   btn:Show()
--       -- end
--     else
--       MainMenuBar:HideBase()
--       Bar2:HideBase()
--       -- for _,btn in pairs(MainMenuBar.actionButtons) do
--       --   btn:Hide()
--       -- end
--       -- for _,btn in pairs(Bar2.actionButtons) do
--       --   btn:Hide()
--       -- end
--     end
--   end
-- end

-- -- enter combat
-- function BarControl:PLAYER_REGEN_DISABLED()
--   self.inCombat = true
--   self:update()
-- end

-- -- leave combat
-- function BarControl:PLAYER_REGEN_ENABLED()
--   self.inCombat = false
--   self:update()
-- end

-- function BarControl:PLAYER_TARGET_CHANGED()
--   self.hasTarget = UnitExists("target")
--   self:update()
-- end

-- function BarControl:PLAYER_ENTERING_WORLD(login, reload)
--   if login or reload then
--     -- Bar2:SetParent(UIParent)
--     self.vis = nil
--     self.hasTarget = UnitExists("target")
--     self.inCombat = UnitAffectingCombat("player")
--     self:update()
--   end
-- end
