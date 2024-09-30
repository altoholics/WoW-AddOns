local ADDON_NAME, ns = ...
local ui = ns.ui
local views = ns.views

-- set up the main addon window
local Class, TitleFrame, Tooltip = ns.lua.Class, ui.TitleFrame, ui.Tooltip
local RaceGridView, SummaryView, DetailView = views.RaceGridView, views.SummaryView, views.DetailView

local viewIdx = {"raceGrid", "raceGrid", "summary", "detail"}

local MainWindow = Class(TitleFrame, function(self)
  -- add the contents
  self.views = {}
  self.views.raceGrid = RaceGridView:new{
    parent = self,
    position = {
      topLeft = {3, -27},
    },
  }

  self.views.summary = SummaryView:new{
    parent = self,
    position = {
      topLeft = {3, -30},
    },
  }

  self.views.detail = DetailView:new{
    parent = self,
    position = {
      topLeft = {3, -32},
    },
  }

  local defaultView = ns.db.settings.defaultView
  self:view(viewIdx[defaultView])
  if defaultView == 2 then
    self.views.raceGrid:showHorde()
  end

  -- view control toolip
  self.viewSelector = Tooltip:new{
    position = {
      topLeft = {self.titlebar.frame, ui.edge.BottomLeft, 6, 3},
      width = 60,
    },
    lines = {
      {
        text = "Alliance",
        background = {0, 0, 0, 0},
        onEnter = function(line) line.background:Color(1, 1, 1, 0.2) end,
        onLeave = function(line) line.background:Color(1, 1, 1, 0) end,
        onClick = function() self:view("raceGrid"); self.views.raceGrid:showAlliance(); self.viewSelector:hide() end,
      },
      {
        text = "Horde",
        background = {0, 0, 0, 0},
        onEnter = function(line) line.background:Color(1, 1, 1, 0.2) end,
        onLeave = function(line) line.background:Color(1, 1, 1, 0) end,
        onClick = function() self:view("raceGrid"); self.views.raceGrid:showHorde(); self.viewSelector:hide() end,
      },
      {
        text = "Summary",
        background = {0, 0, 0, 0},
        onEnter = function(line) line.background:Color(1, 1, 1, 0.2) end,
        onLeave = function(line) line.background:Color(1, 1, 1, 0) end,
        onClick = function() self:view("summary"); self.viewSelector:hide() end,
      },
      {
        text = "Detail",
        background = {0, 0, 0, 0},
        onEnter = function(line) line.background:Color(1, 1, 1, 0.2) end,
        onLeave = function(line) line.background:Color(1, 1, 1, 0) end,
        onClick = function() self:view("detail"); self.viewSelector:hide() end,
      },
    },
  }
  self.titlebar.icon.frame:SetScript("OnMouseUp", function()
    self.viewSelector:toggle()
  end)
end, {
  name = ADDON_NAME,
  title = ADDON_NAME,
  position = {
    center = {},
  },
  special = true,
})

function MainWindow:view(name)
  if self._view then self._view:hide() end
  self._view = self.views[name]
  if self._view._title then
    self:Title(ADDON_NAME.." | "..self._view._title)
  else
    self:Title(ADDON_NAME)
  end
  self._view:show()
  self:width(self._view:width()  + 6)
  self:height(self._view:height() + 30)
end

function ns:Open()
  if not ns.MainWindow then
    ns.MainWindow = MainWindow:new{}
  end

  ns.MainWindow:show()
end

function ns:view(name)
  self:Open()
  ns.MainWindow:view(name)
end

function ns:CompartmentClick() -- buttonName = (LeftButton | RightButton | MiddleButton)
  self:Open()
end
