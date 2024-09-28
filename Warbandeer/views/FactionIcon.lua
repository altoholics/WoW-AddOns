local _, ns = ...

local Class, Frame = ns.lua.Class, ns.ui.Frame

-- todo: make button
local FactionIcon = Class(Frame, function(o)
  o.allianceIcon = "Interface/Icons/ui_allianceicon"
  o.hordeIcon = "Interface/Icons/ui_hordeicon"
  o.isAlliance = true
  o:withTextureArtwork("factionIcon", {
    positionAll = true,
    coords = {0.1, 0.9, 0.1, 0.9},
    texturePath = o.allianceIcon,
  })
end)
ns.views.FactionIcon = FactionIcon

function FactionIcon:swap()
  self.isAlliance = not self.isAlliance
  self.factionIcon:setTexture(self.isAlliance and self.allianceIcon or self.hordeIcon)
end
