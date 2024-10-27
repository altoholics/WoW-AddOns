local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class

local UtilityBar2 = Class(ns.VerticalBar, function(self)
  self.tooltipPoint = {ui.edge.Left, self._widget, ui.edge.Right, -2, 0}

  -- party/raid buffs
  self.fortitude = self:addSpellButton(21562)
  self.aranceInt = self:addSpellButton(1459)
  self.motw = self:addSpellButton(1126)
  self.shout = self:addSpellButton(6673)

  self.refreshments = self:addSpellButton(190336)

  self.sanctification = self:addSpellButton(433568)

  -- resurrect
  self.resurrect = self:addSpellButton(212036) or self:addSpellButton(2006)
  self.revive = self:addSpellButton(50769)
  self.rebirth = self:addSpellButton(20484)
  self.raiseAlly = self:addSpellButton(61999)
  self.rebirth = self:addSpellButton(7328)

  -- soothe
  self.mindSoothe = self:addSpellButton(453)
  self.dominateMind = self:addSpellButton(205364)
  self.mindVision = self:addSpellButton(2096)
  self.soothe = self:addSpellButton(2908)

  self.runeforging = self:addSpellButton(53428)
  self.pathOfFrost = self:addSpellButton(3714)

  self.contemplation = self:addSpellButton(121183)

  -- stance
  self.defensive = self:addSpellButton(386208)
  self.berserker = self:addSpellButton(386196)

  self.twoForms = self:addSpellButton(68996)
  self.darkFlight = self:addSpellButton(68992)

  self.bear = self:addSpellButton(5487)
  self.cat = self:addSpellButton(768)
  self.traval = self:addSpellButton(783)

  self.crusader = self:addSpellButton(32223)
  self.devotion = self:addSpellButton(465)
  self.concentration = self:addSpellButton(317920)

  self:UpdateHeight()
end, {
  name = "ShadowsOfUIUtilBar2",
  alpha = 0.5,
  mouseOverAlpha = 1,
  position = {
    Left = {},
    Width = 48,
  },
  firstButtonPoint = "TopLeft",
})
ns.UtilityBar2 = UtilityBar2
