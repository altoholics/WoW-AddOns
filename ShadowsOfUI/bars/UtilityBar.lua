local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Label, Frame = ui.Label, ui.Frame
local GetMountInfoByID, GetSpellName, strmatch = C_MountJournal.GetMountInfoByID, ns.wow.GetSpellName, strmatch -- luacheck: globals C_MountJournal strmatch

local FlashMsg = Class(Frame, function(self)
  self.label = Label:new{
    parent = self,
    fontInfo = {'fonts/FRIZQT__.TTF', 20, ''},
    color = ns.Colors.Gold,
    position = {
      Right = {},
    },
  }
  self.anim = self._widget:CreateAnimationGroup()
  self.anim:SetToFinalAlpha(true)
  self.fade = self.anim:CreateAnimation('Alpha')
  self.fade:SetStartDelay(5)
  self.fade:SetDuration(10)
  self.fade:SetFromAlpha(1)
  self.fade:SetToAlpha(0)
end, {
  parent = ns.wowui.UIParent,
  position = {
    Width = 1,
    Height = 1,
  },
})

function FlashMsg:Text(text)
  self.label:Text(text)
end

function FlashMsg:Play()
  self.anim:Play()
end

local UtilityBar = Class(ns.VerticalBar, function(self)
  self.tooltipPoint = {ui.edge.Right, self._widget, ui.edge.Left, -2, 0}
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
  self.dreamwalk = self:addSpellButton(193753)

  -- mounts
  self.flightStyle = self:addSpellButton(436854) -- switch flight style
  -- https://wowpedia.fandom.com/wiki/MountID
  self.mount = self:addMountButton(ns.db.settings.actionBars.mount or 1799, "$parentMount", "CTRL-R", {
    OnChange = function(s, mountId)
      local _, spellId, icon = GetMountInfoByID(mountId)
      self.mount._widget:SetNormalTexture(icon)
      self.mount:Attribute("spell", GetSpellName(spellId))
      self.mount.itemId = mountId
      self.mount.tooltip.mountSpellId = spellId
      ns.db.settings.actionBars.mount = mountId
    end,
  }) -- Eve's Ghastly Rider
  self.shopMount = self:addMountButton(2237, "$parentShopMount", "CTRL-SHIFT-R") -- Grizzly Hills Packmaster
  self.aucMount = self:addMountButton(2265, "$parentAucMount", "CTRL-ALT-R") -- Trader's Gilded Brutosaur
  self.waterMount = self:addMountButton(855) -- darkwater skate
  self.bank = self:addSpellButton(83958) -- guild perk: mobile banking
  self.warband = self:addSpellButton(460905) -- warband bank distance inhibitor (460925, 465226)

  -- professions
  self.herbalism = self:addSpellButton(193290)
  self.overloadHerb = self:addOffsetSpellButton(423395, nil, self.herbalism)
  self.mining = self:addSpellButton(2656)
  self.overloadOre = self:addOffsetSpellButton(423394, nil, self.mining)
  self.skinning = self:addSpellButton(194174)
  self.sharpen = self:addOffsetSpellButton(440977, nil, self.skinning)

  self.alchemy = self:addSpellButton(195095)

  self.blacksmithing = self:addSpellButton(195097)

  self.enchanting = self:addSpellNamedButton(264455)
  self.disenchant = self.enchanting and self:addOffsetSpellButton(13262, nil, self.enchanting)

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

  self.picking = self:addSpellButton(1804) -- lock picking

  self:UpdateHeight()
  if self.raft then
    self:Width(self.iconSize + 2*self.smallSize)
  end
end, {
  name = "ShadowsOfUIUtilBar",
  alpha = 0.5,
  mouseOverAlpha = 1,
  position = {
    Right = {},
    Width = 48,
  },
  firstButtonPoint = "TopRight",
  events = {"CHAT_MSG_SKILL"},
})
ns.UtilityBar = UtilityBar

function UtilityBar:CHAT_MSG_SKILL(text, p1, _, _, p2)
  if p2 ~= "" or p2 ~= p1 then return end
  local skill, level = strmatch(text, 'Your skill in ([%a ]+) has increased to (%d+).')
  if not skill then return end
  if not self.flash then self.flash = FlashMsg:new{} end
  local btn
  if skill == "Khaz Alhar Herbalism" then btn = self.herbalism
  elseif skill == "Khaz Algar Mining" then btn = self.mining
  elseif skill == "Khaz Algar Skinning" then btn = self.skinning
  elseif skill == "Khaz Algar Alchemy" then btn = self.alchemy
  elseif skill == "Khaz Algar Blacksmithing" then btn = self.blacksmithing
  elseif skill == "Khaz Algar Enchanting" then btn = self.enchanting
  elseif skill == 'Khaz Algar Engineering' then btn = self.engineering
  elseif skill == 'Khaz Algar Incsription' then btn = self.inscription
  elseif skill == 'Khaz Algar Jewlcrafting' then btn = self.jewelcrafting
  elseif skill == 'Khaz Algar Leatherworking' then btn = self.leatherworking
  elseif skill == 'Khaz Algar Tailoring' then btn = self.tailoring
  end
  if btn then
    self.flash:Text('Skill Up! '..level)
    self.flash:Right(btn, ui.edge.Left, -25, 0)
    self.flash:Play()
  end
end
