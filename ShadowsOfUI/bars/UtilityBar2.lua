local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class

local UtilityBar2 = Class(ns.VerticalBar, function(self)
  self.tooltipPoint = {ui.edge.Left, self.frame, ui.edge.Right, -2, 0}

  -- party/raid buffs
  self.fortitude = self:addSpellButton(21562)

  -- resurrect
  self.resurrect = self:addSpellButton(212036) or self:addSpellButton(2006)

  -- soothe
  self.mindSoothe = self:addSpellButton(453)
  self.dominateMind = self:addSpellButton(205364)
  self.mindVision = self:addSpellButton(2096)

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
