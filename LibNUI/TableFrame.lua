local _, ns = ...
local ui = ns.ui
local tinsert = ns.lua.tinsert
local Class, Frame, BgFrame = ns.lua.Class, ui.Frame, ui.BgFrame
local Center, Middle, Left = ui.justify.Center, ui.justify.Middle, ui.justify.Left
local TopLeft, TopRight, BottomLeft, Right = ui.edge.TopLeft, ui.edge.TopRight, ui.edge.BottomLeft, ui.edge.Right
local Bottom = ui.edge.Bottom

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
    self:withLabel({
      text = self.label,
      position = {left = {2, 0}},
      template = self.font,
      color = self.color or {1, 1, 1, 1},
    })
  end
end, {
  level = 2,
})

local TableCol = Class(BgFrame, function(self)
  self:withLabel({
    text = self.label,
    position = {
      topLeft = {},
      bottomRight = {self.frame, TopRight, 0, -self.headerHeight},
    },
    template = self.font,
    color = self.color or {1, 215/255, 0, 1},
    justifyH = Center,
    justifyV = Middle,
  })
end, {
  level = 1,
})

-- making a table: https://www.wowinterface.com/forums/showthread.php?t=58670
local TableFrame = Class(Frame, function(self)
  self.numCols = self.numCols or (self.colNames and #self.colNames) or 0
  self.numRows = self.numRows or (self.rowNames and #self.rowNames) or 0

  if not self.colNames and self.colInfo then
    self.colNames = {}
    for _,i in ipairs(self.colInfo) do tinsert(self.colNames, i.name) end
  end

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
        label = self.colNames[i],
        headerHeight = self.headerHeight,
        position = {
          topLeft = i == 1 and {self.offsetX, 0} or {self.cols[i-1].frame, TopRight},
          bottom = {self.frame, Bottom},
          width = w,
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
        label = self.rowNames[i],
        position = {
          topLeft = i == 1 and {0, -self.offsetY} or {self.rows[i-1].frame, BottomLeft},
          right = {self.frame, Right},
          height = h,
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

  self:width(width)
  self:height(height)
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
    label = self.colInfo[n].name,
    headerHeight = self.headerHeight,
    position = {
      topLeft = n == 1 and {self.offsetX, 0} or {self.cols[n-1].frame, TopRight},
      bottom = {self.frame, Bottom},
      width = w,
    },
    font = self.colHeaderFont or self.headerFont,
    backdrop = self.colInfo and self.colInfo[n].backdrop or
      {color = {0, 0, 0, math.fmod(n, 2) == 0 and 0.6 or 0.4}},
  })
  self:width(self:width()+w)
  return self
end

function TableFrame:addRow(info)
  local n = #self.rows + 1
  self.rowInfo[n] = info
  tinsert(self.cells, {})
  local h = self.rowInfo and self.rowInfo[n].height or self.cellHeight
  tinsert(self.rows, n, TableRow:new{
    parent = self,
    label = self.rowInfo[n].name,
    position = {
      topLeft = n == 1 and {0, -self.offsetY} or {self.rows[n-1].frame, BottomLeft},
      right = {self.frame, Right},
      height = h,
    },
    backdrop = self.rowInfo and self.rowInfo[n].backdrop or
      {color = {0, 0, 0, math.fmod(n, 2) == 0 and 0.2 or 0}},
  })
  self:height(self:height()+h)
  return self
end

function TableFrame:update()
  for rowN,row in pairs(self.data) do
    if not self.rows[rowN] then self:addRow{} end
    for colN,data in pairs(row) do
      if not self.cols[colN] then self:addCol{} end
      if data and not self.cells[rowN][colN] then
        local cell = Frame:new{
          parent = self,
          level = 3,
          position = {
            topLeft = {self.cols[colN].frame, TopLeft, 0, (rowN-1) * -self.cellHeight - self.headerHeight},
            width = self.colInfo[colN].width - 6,
            height = self.cellHeight,
          },
        }
        local t = data
        if type(data) == "table" then
          t = data.text
          if data.onClick then cell.frame:SetScript("OnMouseUp", function() data.onClick(cell) end) end
          if data.onEnter then cell.frame:SetScript("OnEnter", function() data.onEnter(cell) end) end
          if data.onLeave then cell.frame:SetScript("OnLeave", function() data.onLeave(cell) end) end
        end
        cell:withLabel({
          text = t,
          position = { fill = true },
          justifyH = Left,
        })
        self.cells[rowN][colN] = cell
      end
    end
  end
end
