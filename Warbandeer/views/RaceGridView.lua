local _, ns = ...
local ui = ns.ui

local Class, Frame, Label, Texture = ns.lua.Class, ui.Frame, ui.Label, ui.Texture
local AllianceView, HordeView, FactionIcon = ns.views.AllianceView, ns.views.HordeView, ns.views.FactionIcon

local TopRight = ui.edge.TopRight
local BottomLeft = ui.edge.BottomLeft

local rgba = ns.wowui.rgba

local RaceGridView = Class(Frame, function(o)
  o:Hide()
  o.allianceView = AllianceView:new{parent = o}
  o.hordeView = HordeView:new{parent = o}
  o.hordeView:Hide()

  o.factionIcon = FactionIcon:new{
    parent = o,
    position = {
      TopLeft = {53, -4},
      Width = 32,
      Height = 32,
    },
  }
  o.factionIcon:SetScript("OnMouseUp", function() o:swap() end)

  local status = Frame:new{
    parent = o,
    position = {
      TopLeft = {o, BottomLeft, 0, 12},
      BottomRight = {},
    },
  }
  status.fade = Texture:new{
    parent = status,
    layer = ui.layer.Background,
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0)},
    position = {
      TopLeft = {0, 3},
      BottomRight = {status, TopRight},
    },
  }

  status.count = Label:new{
    parent = status,
    font = ui.fonts.GameFontHighlightSmall,
    text = "Characters: "..ns.api.GetNumCharacters(),
    position = {TopLeft = {4, -2}},
    color = {1, 1, 215/255, 0.8},
  }

  status.maxLevel = Label:new{
    parent = status,
    font = "GameFontHighlightSmall",
    text = ns.wow.maxLevel.."'s: "..ns.api.GetNumMaxLevel(),
    position = {TopLeft = {200, -2}},
    color = {1, 1, 215/255, 0.8},
  }

  o:Width(o.allianceView:Width())
  o:Height(o.allianceView:Height() + 12)
end)
ns.views.RaceGridView = RaceGridView

function RaceGridView:swap()
  self.factionIcon:swap()
  if self.factionIcon.isAlliance then
    self.hordeView:Hide()
    self.allianceView:Show()
  else
    self.allianceView:Hide()
    self.hordeView:Show()
  end
end

function RaceGridView:showHorde() if self.factionIcon.isAlliance then self:swap() end end
function RaceGridView:showAlliance() if not self.factionIcon.isAlliance then self:swap() end end
