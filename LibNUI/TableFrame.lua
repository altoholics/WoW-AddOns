local _, ns = ...
local ui = ns.ui
local tinsert = ns.lua.tinsert
local Class, Frame, BgFrame, Label = ns.lua.Class, ui.Frame, ui.BgFrame, ui.Label
local Center, Middle, Left = ui.justify.Center, ui.justify.Middle, ui.justify.Left
local TopRight, BottomLeft, Right = ui.edge.TopRight, ui.edge.BottomLeft, ui.edge.Right
local Top, Bottom = ui.edge.Top, ui.edge.Bottom

-- Creates an empty frame, but lays out its children in a tabular manner.
-- ops:
--   numCols?     int          - defaults to count of column names
--   numRows?     int          - defaults to count of row names
--   colNames?    string array - list of header names at top of columns
--   rowNames?    string array - list of header names at left of rows
--   cellWidth   int          - width of cells in pixels
--   cellHeight  int          - height of cells in pixels

local TableRow = Class(BgFrame, function(self)
  if self.label then
    self.label = Label:new{
      parent = self,
      text = self.label,
      position = {Left = {2, 0}},
      font = self.font,
      color = self.color or {1, 1, 1, 1},
    }
  end
end, {
  level = 2,
})

local TableCol = Class(BgFrame, function(self)
  self.label = Label:new{
    parent = self,
    text = self.label,
    position = {
      TopLeft = {},
      BottomRight = {self, TopRight, 0, -self.headerHeight},
    },
    font = self.font,
    color = self.color or {1, 215/255, 0, 1},
    justifyH = Center,
    justifyV = Middle,
  }
end, {
  level = 1,
})

-- making a table: https://www.wowinterface.com/forums/showthread.php?t=58670
local TableFrame = Class(Frame, function(self)
  if not self.colNames and self.colInfo then
    self.colNames = {}
    for _,i in ipairs(self.colInfo) do tinsert(self.colNames, i.name) end
  end
  if not self.rowNames and self.rowInfo then
    self.rowNames = {}
    for _,i in ipairs(self.rowInfo) do tinsert(self.rowNames, i.name) end
  end

  self.numCols = self.numCols or (self.colNames and #self.colNames) or 0
  self.numRows = self.numRows or (self.rowNames and #self.rowNames) or 0
  self.headerHeight = self.headerHeight or self.cellHeight
  self.offsetX = self.rowNames ~= nil and self.headerWidth or 0
  self.offsetY = self.colNames ~= nil and self.headerHeight or 0
  self.colHeight = self.cellHeight * (self.numRows) + self.headerHeight
  local width = self.offsetX
  local height = self.offsetY

  self.cols = {}
  self.rows = {}

  if self.colNames then
    for i=1,#self.colNames do
      local w = self.colInfo and self.colInfo[i].width or self.cellWidth
      width = width + w
      tinsert(self.cols, TableCol:new{
        parent = self,
        name = "$parentCol"..i,
        label = self.colNames[i],
        headerHeight = self.headerHeight,
        position = {
          TopLeft = i == 1 and {self.offsetX, 0} or {self.cols[i-1], TopRight},
          Bottom = {},
          Width = w,
        },
        font = self.colHeaderFont or self.headerFont,
        backdrop = self.colInfo and self.colInfo[i].backdrop or
          {color = {0, 0, 0, math.fmod(i, 2) == 0 and 0.6 or 0.4}},
      })
    end
  end

  if self.rowNames then
    for i=1,#self.rowNames do
      local h = self.rowInfo and self.rowInfo[i].height or self.cellHeight
      height = height + h
      tinsert(self.rows, TableRow:new{
        parent = self,
        name = "$parentRow"..i,
        label = self.rowNames[i],
        position = {
          TopLeft = i == 1 and {0, -self.offsetY} or {self.rows[i-1], BottomLeft},
          Right = {},
          Height = h,
        },
        font = self.rowHeaderFont or self.headerFont,
        backdrop = self.rowInfo and self.rowInfo[i].backdrop or
          {color = {0, 0, 0, math.fmod(i, 2) == 0 and 0.2 or 0}}
      })
    end
  end

  self.cells = {}
  for i=1,self.numRows do
    tinsert(self.cells, i, {})
  end

  if not self.colInfo then self.colInfo = {} end
  if not self.rowInfo then self.rowInfo = {} end

  self:Width(width)
  self:Height(height)
  if self.data then self:update() end
end, {
  cellWidth = 100,
  cellHeight = 20,
})
ui.TableFrame = TableFrame

function TableFrame:row(n) return self.rows[n] end
function TableFrame:col(n) return self.cols[n] end

function TableFrame:set(row, col, element)
  if #self.cells < row then
    for i=#self.cells,row do
      tinsert(self.cells, i, {})
    end
  end
  self.cells[row][col] = element
end

function TableFrame:addCol(info)
  local n = #self.cols + 1
  self.colInfo[n] = info
  local w = self.colInfo and self.colInfo[n].width or self.cellWidth
  tinsert(self.cols, TableCol:new{
    parent = self,
    name = "$parentCol"..n,
    label = self.colInfo[n].name,
    headerHeight = self.headerHeight,
    position = {
      TopLeft = n == 1 and {self.offsetX, 0} or {self.cols[n-1], TopRight},
      Bottom = {},
      Width = w,
    },
    font = self.colHeaderFont or self.headerFont,
    backdrop = self.colInfo and self.colInfo[n].backdrop or
      {color = {0, 0, 0, math.fmod(n, 2) == 0 and 0.6 or 0.4}},
  })
  self:Width(self:Width()+w)
  return self
end

function TableFrame:addRow(info)
  local n = #self.rows + 1
  self.rowInfo[n] = info
  tinsert(self.cells, {})
  local h = self.rowInfo and self.rowInfo[n].height or self.cellHeight
  tinsert(self.rows, n, TableRow:new{
    parent = self,
    name = "$parentRow"..n,
    label = self.rowInfo[n].name,
    position = {
      TopLeft = n == 1 and {0, -self.offsetY} or {self.rows[n-1], BottomLeft},
      Right = {},
      Height = h,
    },
    backdrop = self.rowInfo and self.rowInfo[n].backdrop or
      {color = {0, 0, 0, math.fmod(n, 2) == 0 and 0.2 or 0}},
  })
  self:Height(self:Height()+h)
  return self
end

local Cell = Class(Frame, function(self)
  local data = type(self.data) == "table" and self.data or {text = self.data}
  if data.onClick then self:SetScript("OnMouseUp", function() data.onClick(self) end) end
  if data.onEnter then self:SetScript("OnEnter", function() data.onEnter(self) end) end
  if data.onLeave then self:SetScript("OnLeave", function() data.onLeave(self) end) end
  self.label = Label:new{
    parent = self,
    text = data.text,
    color = data.color,
    font = data.font,
    position = { All = true },
    justifyH = data.justifyH or Left,
  }
end, {
  level = 3,
})

function TableFrame:update()
  for rowN,row in pairs(self.data) do
    if not self.rows[rowN] then self:addRow{} end
    for colN,data in pairs(row) do
      if not self.cols[colN] then self:addCol{} end
      if data and not self.cells[rowN][colN] then
        self.cells[rowN][colN] = Cell:new{
          parent = self,
          name = "$parentCell"..rowN.."-"..colN,
          position = {
            Top = {self.rows[rowN], Top},
            Bottom = {self.rows[rowN], Bottom},
            Left = {self.cols[colN], Left},
            Right = {self.cols[colN], Right},
          },
          data = data,
        }
      end
    end
  end
end
