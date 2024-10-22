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
  -- self.views.raceGrid = RaceGridView:new{
  --   parent = self,
  --   position = {
  --     TopLeft = {3, -27},
  --     Hide = true,
  --   },
  -- }

  self.views.summary = SummaryView:new{
    parent = self,
    position = {
      TopLeft = {3, -30},
      Hide = true,
    },
  }

  -- self.views.detail = DetailView:new{
  --   parent = self,
  --   position = {
  --     TopLeft = {3, -32},
  --   },
  -- }

  local defaultView = ns.db.settings.defaultView
  self:view(viewIdx[defaultView])
  if defaultView == 2 then
    self.views.raceGrid:showHorde()
  end

  -- view control toolip
  self.viewSelector = Tooltip:new{
    position = {
      TopLeft = {self.titlebar, ui.edge.BottomLeft, 6, 3},
      Width = 60,
    },
    lines = {
      {
        text = "Alliance",
        background = {0, 0, 0, 0},
        onEnter = function(line) line.background:Color(1, 1, 1, 0.2) end,
        onLeave = function(line) line.background:Color(1, 1, 1, 0) end,
        onClick = function() self:view("raceGrid"); self.views.raceGrid:showAlliance(); self.viewSelector:Hide() end,
      },
      {
        text = "Horde",
        background = {0, 0, 0, 0},
        onEnter = function(line) line.background:Color(1, 1, 1, 0.2) end,
        onLeave = function(line) line.background:Color(1, 1, 1, 0) end,
        onClick = function() self:view("raceGrid"); self.views.raceGrid:showHorde(); self.viewSelector:Hide() end,
      },
      {
        text = "Summary",
        background = {0, 0, 0, 0},
        onEnter = function(line) line.background:Color(1, 1, 1, 0.2) end,
        onLeave = function(line) line.background:Color(1, 1, 1, 0) end,
        onClick = function() self:view("summary"); self.viewSelector:Hide() end,
      },
      {
        text = "Detail",
        background = {0, 0, 0, 0},
        onEnter = function(line) line.background:Color(1, 1, 1, 0.2) end,
        onLeave = function(line) line.background:Color(1, 1, 1, 0) end,
        onClick = function() self:view("detail"); self.viewSelector:Hide() end,
      },
    },
  }
  self.titlebar.icon:SetScript("OnMouseUp", function()
    self.viewSelector:Toggle()
  end)
end, {
  name = ADDON_NAME,
  title = ADDON_NAME,
  position = {
    Center = {},
  },
  special = true,
})

function MainWindow:view(name)
  if self._view then self._view:Hide() end
  self._view = self.views[name]
  if self._view._title then
    self:Title(ADDON_NAME.." | "..self._view._title)
  else
    self:Title(ADDON_NAME)
  end
  self._view:Show()
  self:Width(self._view:Width()  + 6)
  self:Height(self._view:Height() + 30)
end

function ns:Open()
  if not ns.MainWindow then
    ns.MainWindow = MainWindow:new{}
  end

  ns.MainWindow:Show()
end

function ns:view(name)
  self:Open()
  ns.MainWindow:view(name)
end

function ns:CompartmentClick() -- buttonName = (LeftButton | RightButton | MiddleButton)
  self:Open()
end
