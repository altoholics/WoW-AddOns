local _, ns = ...
local ui, Player, Items = ns.ui, ns.wow.Player, ns.wow.Items
local Class, tinsert, Fill = ns.lua.Class, ns.lua.tinsert, ns.lua.Fill
local Frame, Button, SecureButton = ui.Frame, ui.Button, ui.SecureButton
local GetSpellName, GetSpellTexture = ns.wow.GetSpellName, ns.wow.GetSpellTexture
local HasToy, IsSpellKnown = Player.HasToy, Player.IsSpellKnown
local IsMountCollected, GetMountIcon = Player.IsMountCollected, Player.GetMountIcon
local Bottom = ui.edge.Bottom

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
  -- Draenic Hologem
  -- Deepdweller's Earthen Hearthstone
  self.hearth = self:addToyButton(172179) -- button 1: hearthstone
  self.dalaran = self:addToyButton(140192) -- button 2: Dalaran Hearthstone
  self.garrison = self:addToyButton(110560) -- button 3: Garrison Hearthstone

  -- mounts
  self.flightStyle = self:addSpellButton(436854) -- switch flight style
  -- https://wowpedia.fandom.com/wiki/MountID
  self.mount = self:addMountButton(1799, 419345, "$parentMount", "CTRL-R") -- Eve's Ghastly Rider
  self.shopMount = self:addMountButton(2237, 457485, "$parentShopMount", "CTRL-SHIFT-R") -- Grizzly Hills Packmaster
  self.waterMount = self:addMountButton(855, 228919) -- darkwater skate
  self.bank = self:addSpellButton(83958) -- guild perk: mobile banking
  self.warband = self:addSpellButton(460905) -- warband bank distance inhibitor (460925, 465226)

  -- professions
  self.herbalism = self:addSpellButton(193290)
  self.overloadHerb = self:addOffsetSpellButton(423395, nil, self.herbalism)
  self.mining = self:addSpellButton(2656)
  self.overloadOre = self:addOffsetSpellButton(423394, nil, self.mining)
  self.skinning = self:addSpellButton(194174)

  self.alchemy = self:addSpellButton(195095)

  self.blacksmithing = self:addSpellButton(264434)

  self.enchanting = self:addSpellButton(264455)
  self.disenchant = self:addOffsetSpellButton(13262, nil, self.enchanting)

  self.engineering = self:addSpellButton(195112)

  self.inscription = self:addSpellButton(195115)

  self.jewelcrafting = self:addSpellButton(195116)

  self.leatherworking = self:addSpellButton(195119)

  self.tailoring = self:addSpellButton(195126)

  -- secondary
  self.fishing = self:addSpellButton(271990)
  self.fish = self:addOffsetSpellButton(131474, nil, self.fishing)
  self.raft = self.fish and self:addOffsetToyButton(85500, self.fish, -self.spacing)

  self.cooking = self:addSpellButton(158765) or self:addSpellButton(88053)
  self.fire = self.cooking and self:addOffsetSpellButton(818, nil, self.cooking)

  self:height(#self.buttons * self.iconSize + (#self.buttons-1) * self.spacing)
  if self.raft then
    self:width(self.iconSize + 2*self.smallSize)
  end

  self.frame:SetAlpha(0.5)
  self.frame:SetScript("OnEnter", function(f) f:SetAlpha(1) end)
  self.frame:SetScript("OnLeave", function(f) if not f:IsMouseOver() then f:SetAlpha(0.5) end end)
end, {
  parent = ns.wowui.UIParent,
  name = "ShadowsOfUIUtilBar",
  spacing = 2,
  iconSize = 30,
  smallSize = 20,
  position = {
    right = {},
    width = 48,
  },
})
ns.UtilityBar = UtilityBar

function UtilityBar:addButton(ops)
  local btn = Button:new(Fill(ops, {
    parent = self,
    position = {
      topRight = #self.buttons == 0 and {} or nil,
      top = #self.buttons > 0 and {self.buttons[#self.buttons].frame, Bottom, 0, -self.spacing} or nil,
      width = self.iconSize,
      height = self.iconSize,
    },
    normal = {
      coords = {0.07, 0.93, 0.07, 0.93},
    },
    tooltip = {
      owner = {self.frame, "ANCHOR_NONE"},
      point = {ui.edge.Right, self.frame, ui.edge.Left, -2, 0},
    },
  }))
  tinsert(self.buttons, btn)
  return btn
end

function UtilityBar:addSecureButton(ops)
  local btn = SecureButton:new(Fill(ops, {
    parent = self,
    position = {
      topRight = #self.buttons == 0 and {} or nil,
      top = #self.buttons > 0 and {self.buttons[#self.buttons].frame, Bottom, 0, -self.spacing} or nil,
      width = self.iconSize,
      height = self.iconSize,
    },
    normal = {
      coords = {0.07, 0.93, 0.07, 0.93},
    },
    tooltip = {
      owner = {self.frame, "ANCHOR_NONE"},
      point = {ui.edge.Right, self.frame, ui.edge.Left, -2, 0},
    },
  }))
  if not ops.offset then tinsert(self.buttons, btn) end
  return btn
end

function UtilityBar:addToyButton(id)
  return HasToy(id) and self:addSecureButton{
    normal = {
      texture = Items.GetIcon(id),
    },
    actions = {
      {
        type = "toy",
        toy = id,
      },
    },
    tooltip = { toyId = id },
  }
end

function UtilityBar:addOffsetToyButton(id, target, x, y)
  return HasToy(id) and self:addSecureButton{
    offset = true,
    level = target.frame:GetFrameLevel() + 1,
    position = {
      top = false,
      right = {target.frame, ui.edge.Left, x or 2 * self.spacing, y or 0},
      width = self.smallSize,
      height = self.smallSize,
    },
    normal = {
      texture = Items.GetIcon(id),
    },
    actions = {
      {
        type = "toy",
        toy = id,
      },
    },
    tooltip = { toyId = id },
  }
end

function UtilityBar:addSpellButton(id, icon)
  return IsSpellKnown(id) and self:addSecureButton{
    normal = {
      texture = icon or GetSpellTexture(id),
    },
    actions = {
      {
        type = "spell",
        spell = id,--GetSpellName(id),
      },
    },
    tooltip = { spellId = id },
  }
end

function UtilityBar:addOffsetSpellButton(id, icon, target, x, y)
  return IsSpellKnown(id) and self:addSecureButton{
    offset = true,
    level = target.frame:GetFrameLevel() + 1,
    position = {
      top = false,
      right = {target.frame, ui.edge.Left, x or 2 * self.spacing, y or 0},
      width = self.smallSize,
      height = self.smallSize,
    },
    normal = {
      texture = icon or GetSpellTexture(id),
    },
    actions = {
      {
        type = "spell",
        spell = GetSpellName(id),
      },
    },
    tooltip = { spellId = id },
  }
end

function UtilityBar:addMountButton(id, spell, name, bind)
  return IsMountCollected(id) and self:addSecureButton{
    name = name,
    normal = {
      texture = GetMountIcon(id),
    },
    actions = {
      {
        type = "spell",
        spell = GetSpellName(spell),
      },
    },
    bindLeftClick = bind,
    tooltip = { mountSpellId = spell },
  }
end
