local _, ns = ...
local ui = ns.ui

local Class, Frame, TableFrame = ui.Class, ui.Frame, ui.TableFrame

local ALLIANCE_RACES, CLASS_NAMES, CLASSES = ns.ALLIANCE_RACES, ns.CLASS_NAMES, ns.CLASSES

local CELL_WIDTH = 85
local CELL_HEIGHT = 24
local HeaderHeight = CELL_HEIGHT * 1.5

local AllianceView = Class(TableFrame, function(o)
  -- color the backgrounds of the rows by class color
  for i=1,ns.g.NUM_CLASSES do
    o:row(i):backdropColor(CLASSES[i].color.r, CLASSES[i].color.g, CLASSES[i].color.b, 0.2)
  end

  local toons = ns.api.GetAllianceCharacters()
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
        size = {CELL_WIDTH, CELL_HEIGHT},
      },
      justifyH = "CENTER",
      justifyV = "MIDDLE",
      color = data.level ~= ns.g.maxLevel and {0.7, 0.7, 0.7, 1}
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
      if data.cooking then
        GameTooltip:AddDoubleLine(
          "Cooking",
          data.cooking.skillLevel.."/"..data.cooking.maxSkill,
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
  CELL_WIDTH = CELL_WIDTH,
  CELL_HEIGHT = CELL_HEIGHT,
  headerHeight = HeaderHeight,
  colNames = ALLIANCE_RACES,
  rowNames = CLASS_NAMES,
  position = {
    topLeft = {},
    width = (#ALLIANCE_RACES + 1) * CELL_WIDTH,
    height = #CLASS_NAMES * CELL_HEIGHT + HeaderHeight,
  },
  headerFont = ui.fonts.GameFontHighlightSmall,
})
ns.views.AllianceView = AllianceView
