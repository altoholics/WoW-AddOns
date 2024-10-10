local _, ns = ...
local ui, Player = ns.ui, ns.wow.Player
local Class, tinsert = ns.lua.Class, ns.lua.tinsert
local Frame, Button, SecureButton = ui.Frame, ui.Button, ui.SecureButton
local GetSpellName, GetSpellTexture = ns.wow.GetSpellName, ns.wow.GetSpellTexture
local HasToy, UseToy, IsSpellKnown = Player.HasToy, Player.UseToy, Player.IsSpellKnown
local IsMountUsable, GetMountIcon, Mount = Player.IsMountUsable, Player.GetMountIcon, Player.Mount

-- for showing "clock-like" sweep and leading-edge effects
-- https://wowpedia.fandom.com/wiki/UIOBJECT_Cooldown

-- if EditModeManagerFrame then
--   EventRegistry:RegisterCallback("EditMode.Enter", function() self:Unlock(true) end)
--   EventRegistry:RegisterCallback("EditMode.Exit", function() self:Lock() end)

local UtilityBar = Class(Frame, function(self)
  self.buttons = {}
  -- 791	162973	WoW Icon update	Greatfather Winter's Hearthstone	World Event	8.0.1
  -- 792	163045	WoW Icon update	Headless Horseman's Hearthstone	World Event	8.0.1
  -- 916	165669	WoW Icon update	Lunar Elder's Hearthstone		8.1.0
  -- 917	165670	WoW Icon update	Peddlefeet's Lovely Hearthstone		8.1.0
  -- 918	165802	WoW Icon update	Noble Gardener's Hearthstone		8.1.5
  -- 919	166746	WoW Icon update	Fire Eater's Hearthstone		8.1.5
  -- 920	166747	WoW Icon update	Brewfest Reveler's Hearthstone		8.1.5
  -- 981	172179	WoW Icon update	Eternal Traveler's Hearthstone	Promotion	8.3.0
  -- 1070	182773	Shadowlands	Necrolord Hearthstone		9.0.1
  -- 1095	180290	Shadowlands	Night Fae Hearthstone	Vendor	9.0.2
  -- 1096	184353	Shadowlands	Kyrian Hearthstone	Vendor	9.0.2
  -- 1173	188952	Shadowlands	Dominated Hearthstone	Achievement	9.2.0
  -- 1175	190196		Enlightened Hearthstone	❓	9.2.0
  -- 1192	193588	WoW Icon update	Timewalker's Hearthstone	Promotion	9.2.5
  -- 1236	200630	WoW Icon update	Ohn'ir Windsage's Hearthstone		10.0.0
  -- 1293	140192	Legion	Dalaran Hearthstone	Quest	10.1.5
  -- 1294	110560	Warlords of Draenor	Garrison Hearthstone	Quest	10.1.5
  if HasToy(172179) then
    -- button 1: hearthstone
    self.hearth = SecureButton:new{
      parent = self,
      position = {
        top = {self.frame, ui.edge.Top},
        width = 24,
        height = 24,
      },
      normal = {
        texture = GetItemIcon(172179),
        coords = {0.07, 0.93, 0.07, 0.93},
      },
      actions = {
        {
          type = "toy",
          toy = 172179,
        },
      },
    }
    tinsert(self.buttons, self.hearth)
  end
  if HasToy(140192) then
    -- button 2: Dalaran Hearthstone
    self.dalaran = SecureButton:new{
      parent = self,
      position = {
        top = {self.buttons[#self.buttons].frame or self.frame, ui.edge.Bottom, 0, -2},
        width = 24,
        height = 24,
      },
      normal = {
        texture = GetItemIcon(140192),
        coords = {0.07, 0.93, 0.07, 0.93},
      },
      actions = {
        {
          type = "toy",
          toy = 140192,
        },
      },
    }
    tinsert(self.buttons, self.dalaran)
  end
  if HasToy(110560) then
    -- button 3: Garrison Hearthstone
    self.garrison = SecureButton:new{
      parent = self,
      position = {
        top = {self.buttons[#self.buttons].frame or self.frame, ui.edge.Bottom, 0, -2},
        width = 24,
        height = 24,
      },
      normal = {
        texture = GetItemIcon(110560),
        coords = {0.07, 0.93, 0.07, 0.93},
      },
      actions = {
        {
          type = "toy",
          toy = 110560,
        },
      },
    }
    tinsert(self.buttons, self.garrison)
  end

  -- mounts
  if IsSpellKnown(436854) then
    self.flightStyle = SecureButton:new{
      parent = self,
      position = {
        top = {self.buttons[#self.buttons].frame or self.frame, ui.edge.Bottom, 0, -2},
        width = 24,
        height = 24,
      },
      normal = {
        texture = GetSpellTexture(436854),
        coords = {0.07, 0.93, 0.07, 0.93},
      },
      actions = {
        {
          type = "spell",
          spell = GetSpellName(436854),
        },
      },
    }
    tinsert(self.buttons, self.flightStyle)
  end
  -- https://wowpedia.fandom.com/wiki/MountID
  if IsMountUsable(1799) then -- Eve's Ghastly Rider
    self.mount = SecureButton:new{
      parent = self,
      name = "$parentMount",
      position = {
        top = {self.buttons[#self.buttons].frame or self.frame, ui.edge.Bottom, 0, -2},
        width = 24,
        height = 24,
      },
      normal = {
        texture = GetMountIcon(1799),
        coords = {0.07, 0.93, 0.07, 0.93},
      },
      actions = {
        {
          type = "spell",
          spell = GetSpellName(419345),
        },
      },
      bindLeftClick = "CTRL-R",
    }
    tinsert(self.buttons, self.mount)
  end
  if IsMountUsable(2237) then -- Grizzly Hills Packmaster
    self.shopMount = SecureButton:new{
      parent = self,
      position = {
        top = {self.buttons[#self.buttons].frame or self.frame, ui.edge.Bottom, 0, -2},
        width = 24,
        height = 24,
      },
      normal = {
        texture = GetMountIcon(2237),
        coords = {0.07, 0.93, 0.07, 0.93},
      },
      actions = {
        {
          type = "spell",
          spell = GetSpellName(457485),
        },
      },
    }
    tinsert(self.buttons, self.shopMount)
  end

  self:height(#self.buttons * 24 + (#self.buttons-1) * 2)
end, {
  name = "ShadowsOfUIBars",
  position = {
    right = {},
    width = 24,
  },
})

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_ActionBar/Mainline/ActionButton.lua

local ActionBars = Class(nil, function(self)
  self.utility = UtilityBar:new{}
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
