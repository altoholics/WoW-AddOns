local _, ns = ...
local ui = ns.ui

local tinsert = ns.lua.tinsert
local Class, TableFrame = ns.lua.Class, ui.TableFrame

local SummaryView = Class(TableFrame, function(self)
  local toons = ns.api.GetAllCharacters() -- returns a copy
  -- sort by level, then ilvl, then name
  table.sort(toons, function(c1, c2)
    if c1.level ~= c2.level then return c1.level > c2.level end
    if c1.ilvl ~= c2.ilvl then return c1.ilvl > c2.ilvl end
    return c1.name > c2.name
  end)

  self.data = {}
  for _,t in pairs(toons) do
    tinsert(self.data, {
      t.name,
      t.level,
      t.ilvl
    })
  end

  self:width(166)
  self:height(#self.data * self.cellHeight + self.headerHeight + 6)
  self:update()
end, {
  colInfo = {
    { name = "Character", width = 80, },
    { name = "Level", width = 40 },
    { name = "iLvl", width = 40 },
  },
})
ns.views.SummaryView = SummaryView
