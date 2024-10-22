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
