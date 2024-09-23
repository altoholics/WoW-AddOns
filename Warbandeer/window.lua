local ADDON_NAME, ns = ...
local ui = ns.ui
local views = ns.views

-- set up the main addon window
local Class, TitleFrame = ui.Class, ui.TitleFrame
local RaceGridView = views.RaceGridView

local MainWindow = Class(TitleFrame, function(self)
  -- add the contents
  self.views = {}
  self.views.raceGrid = RaceGridView:new{
    parent = self,
    position = {
      topLeft = {3, -27},
      bottomRight = {3, 3},
    },
  }

  self:width(self.views.raceGrid:width() + 6)
  self:height(self.views.raceGrid:height() + 30)
end, {
  name = ADDON_NAME,
  title = ADDON_NAME,
  position = {
    center = {},
  },
  special = true,
})

function ns.Open()
  if not ns.MainWindow then
    ns.MainWindow = MainWindow:new{}
  end

  ns.MainWindow:show()
end

function ns:CompartmentClick() -- buttonName = (LeftButton | RightButton | MiddleButton)
  self:Open()
end
