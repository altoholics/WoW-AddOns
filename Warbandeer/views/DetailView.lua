local _, ns = ...
local ui = ns.ui
local Class, Frame = ns.lua.Class, ui.Frame

local DetailView = Class(Frame, function(self)
  local data = ns.api:GetCharacterData()
  self:withLabel("r", {
    text = data.level.." "..data.race.." "..data.className.." on "..data.realm,
    position = {TopLeft = {2, -2}},
  })
  self:withLabel("r2", {
    font = ns.ui.fonts.GameFontHighlightSmall,
    text = "ilvl "..data.ilvl,
    position = {TopLeft = {2, -22}},
  })
  self._title = data.name
end, {
  position = {
    Width = 500,
    Height = 500,
    Hide = true,
  },
})
ns.views.DetailView = DetailView

function DetailView:update()
end
