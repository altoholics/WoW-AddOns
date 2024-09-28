local _, ns = ...
local ui = ns.ui

local Class, Frame = ns.lua.Class, ui.Frame
local AllianceView, HordeView, FactionIcon = ns.views.AllianceView, ns.views.HordeView, ns.views.FactionIcon

local TopLeft, TopRight = ui.edge.TopLeft, ui.edge.TopRight
local BottomLeft, BottomRight = ui.edge.BottomLeft, ui.edge.BottomRight

local rgba = ns.wow.CreateColor

local RaceGridView = Class(Frame, function(o)
  o.allianceView = AllianceView:new{parent = o}
  o.hordeView = HordeView:new{parent = o}
  o.hordeView:hide()

  o.factionIcon = FactionIcon:new{
    parent = o.frame,
    position = {
      topLeft = {53, -4},
      width = 32,
      height = 32,
    },
  }
  o.factionIcon.frame:SetScript("OnMouseUp", function()
    o.factionIcon:swap()
    if o.factionIcon.isAlliance then
      o.hordeView:hide()
      o.allianceView:show()
    else
      o.allianceView:hide()
      o.hordeView:show()
    end
  end)

  local status = Frame:new{
    parent = o.frame,
    position = {
      topLeft = {o.frame, BottomLeft, 0, 12},
      bottomRight = {},
    },
  }
  -- status:addBackdrop({color = {0, 0, 0, 0.2}})
  status:withTextureBackground("fade", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0)},
    clamp = {
      {TopLeft, 0, 3},
      {BottomRight, status.frame, TopRight},
    },
  })

  status:withLabel{
    name = "count",
    font = ui.fonts.GameFontHighlightSmall,
    text = "Characters: "..ns.api.GetNumCharacters(),
    position = {topLeft = {4, -2}},
    color = {1, 1, 215/255, 0.8},
  }

  status:withLabel{
    name = "maxLevel",
    font = "GameFontHighlightSmall",
    text = ns.wow.maxLevel.."'s: "..ns.api.GetNumMaxLevel(),
    position = {topLeft = {200, -2}},
    color = {1, 1, 215/255, 0.8},
  }

  o:width(o.allianceView:width())
  o:height(o.allianceView:height() + 12)
end)
ns.views.RaceGridView = RaceGridView
