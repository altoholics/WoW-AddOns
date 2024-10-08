local _, ns = ...
local ui = ns.ui

local Class, Frame, TableFrame = ns.lua.Class, ui.Frame, ui.TableFrame
local HORDE_RACES, CLASSES = ns.HORDE_RACES, ns.CLASSES

local rowInfo = {}
for i=1,#CLASSES do
  rowInfo[i] = {
    name = CLASSES[i].name,
    backdrop = {color = {CLASSES[i].color.r, CLASSES[i].color.g, CLASSES[i].color.b, 0.2}},
  }
end

local cellWidth = 85
local cellHeight = 24
local HeaderHeight = cellHeight * 1.5

local HordeView = Class(TableFrame, function(o)
  local toons = ns.api.GetHordeCharacters()
  for _,data in pairs(toons) do
    local row = data.classId
    local w = o.cols[1].frame:GetWidth()
    local cell = Frame:new{
      parent = o.frame,
      level = 3,
      position = {
        topLeft = {data.raceIdx * w, (row-1) * -24 - HeaderHeight},
        width = w - 6,
        height = 24 - 10,
      },
    }
    cell:withLabel({
      font = ui.fonts.GameFontHighlightSmall,
      text = data.name,
      position = {
        topLeft = {},
        size = {cellWidth, cellHeight},
      },
      justifyH = "CENTER",
      justifyV = "MIDDLE",
      color = data.level ~= ns.wow.maxLevel and {0.7, 0.7, 0.7, 1}
    })

    -- https://wowpedia.fandom.com/wiki/UIOBJECT_GameTooltip
    cell.frame:SetScript("OnEnter", function()
      GameTooltip:SetOwner(cell.frame, "ANCHOR_RIGHT")
      GameTooltip:SetText(data.name, 1, 1, 1)
      GameTooltip:AddDoubleLine("Level", data.level, nil, nil, nil, 1, 1, 1)
      GameTooltip:AddDoubleLine("iLvl", data.ilvl, nil, nil, nil, 1, 1, 1)
      if data.prof1 then
        GameTooltip:AddDoubleLine(
          ns.api.professionInfo["sl"..data.prof1.skillID].name,
          data.prof1.skillLevel.."/"..data.prof1.maxSkill,
          nil, nil, nil,
          1, 1, 1
        )
      end
      if data.prof2 then
        GameTooltip:AddDoubleLine(
          ns.api.professionInfo["sl"..data.prof2.skillID].name,
          data.prof2.skillLevel.."/"..data.prof2.maxSkill,
          nil, nil, nil,
          1, 1, 1
        )
      end
      if data.fishing then
        GameTooltip:AddDoubleLine(
          "Fishing",
          data.fishing.skillLevel.."/"..data.fishing.maxSkill,
          nil, nil, nil,
          1, 1, 1
        )
      end
      GameTooltip:Show()
    end)
    cell.frame:SetScript("OnLeave", function()
      GameTooltip:Hide()
    end)
  end
end, {
  _title = "Horde",
  cellWidth = cellWidth,
  cellHeight = cellHeight,
  headerWidth = cellWidth,
  headerHeight = HeaderHeight,
  colNames = HORDE_RACES,
  rowInfo = rowInfo,
  position = {
    topLeft = {},
    bottomRight = {},
  },
  headerFont = "GameFontHighlightSmall",
})
ns.views.HordeView = HordeView
