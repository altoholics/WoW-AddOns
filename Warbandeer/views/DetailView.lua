local _, ns = ...
local ui = ns.ui
local Class, Frame = ns.lua.Class, ui.Frame

local DetailView = Class(Frame, function(self)
  local data = ns.api:GetCharacterData()
  self:withLabel("r", {
    text = data.level.." "..data.race.." "..data.className.." on "..data.realm,
    position = {topLeft = {2, -2}},
  })
  self:withLabel("r2", {
    font = ns.ui.fonts.GameFontHighlightSmall,
    text = "ilvl "..data.ilvl,
    position = {topLeft = {2, -22}},
  })
  self._title = data.name
end, {
  position = {
    width = 500,
    height = 500,
  },
})
ns.views.DetailView = DetailView

function DetailView:update()
end
