local _, ns = ...
local ui = ns.ui

local Class, Frame, TableFrame = ui.Class, ui.Frame, ui.TableFrame

local SummaryView = Class(TableFrame, function(self)
  local toons = {}
  for _,data in pairs(ns.api.GetAllCharacters()) do
    table.insert(toons, data)
  end
  table.sort(toons, function(c1, c2)
    if c1.level ~= c2.level then return c1.level > c2.level end
    if c1.ilvl ~= c2.ilvl then return c1.ilvl > c2.ilvl end
    return c1.name > c2.name
  end)
  local i = 0
  for _,data in pairs(toons) do
    self:withLabel{
      name = "Character"..data.name,
      text = data.name,
      position = {
        topLeft = {3, i * -20 - 3},
        size = {80, 20},
      },
      justifyH = "LEFT",
      justifyV = "MIDDLE",
    }
    self:withLabel{
      name = "Character"..data.name.."Level",
      text = data.level,
      position = {
        topLeft = {83, i * -20 - 3},
        size = {40, 20},
      },
      justifyH = "LEFT",
      justifyV = "MIDDLE",
    }
    self:withLabel{
      name = "Character"..data.name.."ItemLevel",
      text = data.ilvl,
      position = {
        topLeft = {123, i * -20 - 3},
        size = {40, 20},
      },
      justifyH = "LEFT",
      justifyV = "MIDDLE",
    }
    i = i + 1
  end

  self:width(166)
  self:height(ns.api.GetNumCharacters() * 20 + 6)
end, {
  CELL_WIDTH = 100,
  CELL_HEIGHT = 20,
})
ns.views.SummaryView = SummaryView
