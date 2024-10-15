local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class

local UtilityBar2 = Class(ns.VerticalBar, function(self)
  self.tooltipPoint = {ui.edge.Left, self.frame, ui.edge.Right, -2, 0}

  -- party/raid buffs
  self.fortitude = self:addSpellButton(21562)
  self.aranceInt = self:addSpellButton(1459)
  self.motw = self:addSpellButton(1126)

  self.refreshments = self:addSpellButton(190336)

  -- resurrect
  self.resurrect = self:addSpellButton(212036) or self:addSpellButton(2006)
  self.revive = self:addSpellButton(50769)
  self.rebirth = self:addSpellButton(20484)
  self.raiseAlly = self:addSpellButton(61999)

  -- soothe
  self.mindSoothe = self:addSpellButton(453)
  self.dominateMind = self:addSpellButton(205364)
  self.mindVision = self:addSpellButton(2096)
  self.soothe = self:addSpellButton(2908)

  self.runeforging = self:addSpellButton(53428)
  self.pathOfFrost = self:addSpellButton(3714)

  self:UpdateHeight()
end, {
  name = "ShadowsOfUIUtilBar2",
  alpha = 0.5,
  mouseOverAlpha = 1,
  position = {
    left = {},
    width = 48,
  },
  firstButtonPoint = "topLeft",
})
ns.UtilityBar2 = UtilityBar2
