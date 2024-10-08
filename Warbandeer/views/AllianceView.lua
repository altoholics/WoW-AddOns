local _, ns = ...
local ui = ns.ui

local Class, TableFrame = ns.lua.Class, ui.TableFrame
local ALLIANCE_RACES, CLASSES = ns.ALLIANCE_RACES, ns.CLASSES

local colInfo = {}
for i=1,#ALLIANCE_RACES do
  colInfo[i] = {
    name = ALLIANCE_RACES[i]
  }
end

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

local AllianceView = Class(TableFrame, function(self)
  self.data = {}
  local toons = ns.api.GetAllianceCharacters()
  for _,data in pairs(toons) do
    if not self.data[data.classId] then self.data[data.classId] = {} end
    self.data[data.classId][data.raceIdx] = {
      text = data.name,
      font = ui.fonts.GameFontHighlightSmall,
      color = data.level ~= ns.wow.maxLevel and {0.7, 0.7, 0.7, 1},
      onEnter = function(cell)
        GameTooltip:SetOwner(cell.frame, "ANCHOR_BOTTOMRIGHT", -10, 10)
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
      end,
      onLeave = function()
        GameTooltip:Hide()
      end
    }
  end
  self:update()
end, {
  _title = "Alliance",
  cellWidth = cellWidth,
  cellHeight = cellHeight,
  headerWidth = 95,
  headerHeight = HeaderHeight,
  colInfo = colInfo,
  rowInfo = rowInfo,
  position = {
    topLeft = {},
    width = (#ALLIANCE_RACES + 1) * cellWidth,
    height = #rowInfo * cellHeight + HeaderHeight,
  },
  headerFont = ui.fonts.GameFontHighlightSmall,
})
ns.views.AllianceView = AllianceView
