local _, ns = ...

local Class, Frame, Texture = ns.lua.Class, ns.ui.Frame, ns.ui.Texture

-- todo: make button
local FactionIcon = Class(Frame, function(self)
  self.allianceIcon = "Interface/Icons/ui_allianceicon"
  self.hordeIcon = "Interface/Icons/ui_hordeicon"
  self.isAlliance = true

  self.factionIcon = Texture:new{
    parent = self,
    layer = ns.ui.layer.Artwork,
    position = { All = true },
    coords = {0.1, 0.9, 0.1, 0.9},
    path = self.allianceIcon,
  }
end)
ns.views.FactionIcon = FactionIcon

function FactionIcon:swap()
  self.isAlliance = not self.isAlliance
  self.factionIcon:Texture(self.isAlliance and self.allianceIcon or self.hordeIcon)
end
