local _, ns = ...
local ui = ns.ui
local tinsert = ns.lua.tinsert
local Class, Frame, BgFrame = ns.lua.Class, ui.Frame, ui.BgFrame
local Center, Middle, Left = ui.justify.Center, ui.justify.Middle, ui.justify.Left
local TopLeft, TopRight = ui.edge.TopLeft, ui.edge.TopRight

-- Creates an empty frame, but lays out its children in a tabular manner.
-- ops:
--   numCols?     int          - defaults to count of column names
--   numRows?     int          - defaults to count of row names
--   colNames?    string array - list of header names at top of columns
--   rowNames?    string array - list of header names at left of rows
--   cellWidth   int          - width of cells in pixels
--   cellHeight  int          - height of cells in pixels

local TableRow = Class(BgFrame, function(self)
  self:topLeft(0, self.index * -self.frame:GetHeight() - self.insetTop)
  self:withLabel({
    text = self.label,
    position = {left = {2, 0}},
    template = self.font,
    color = self.color or {1, 1, 1, 1},
  })
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

  self.headerHeight = self.headerHeight or self.cellHeight
  local offsetX = self.rowNames ~= nil and self.cellWidth or 0
  local offsetY = self.colNames ~= nil and self.headerHeight or 0
  local colHeight = self.cellHeight * (self.numRows) + self.headerHeight
  local rowWidth = self.cellWidth * (self.numCols + 1)

  if not self.colNames and self.colInfo then
    self.colNames = {}
    for _,i in ipairs(self.colInfo) do tinsert(self.colNames, i.name) end
  end

  self.cols = {}
  self.rows = {}

  if self.colNames then
    local left = 0
    for i=1,#self.colNames do
      tinsert(self.cols, TableCol:new{
        parent = self,
        label = self.colNames[i],
        headerHeight = self.headerHeight,
        position = {
          topLeft = {left + offsetX, 0},
          width = self.colInfo and self.colInfo[i].width or self.cellWidth,
          height = colHeight,
        },
        font = self.colHeaderFont or self.headerFont,
        backdrop = self.colInfo and self.colInfo[i].backdrop or
          {color = {0, 0, 0, math.fmod(#self.cols, 2) == 0 and 0.6 or 0.4}},
      })
      left = left + (self.colInfo and self.colInfo[i].width or self.cellWidth)
    end
  end

  if self.rowNames then
    for i=1,#self.rowNames do
      tinsert(self.rows, TableRow:new{
        parent = self,
        index = #self.rows,
        label = self.rowNames[i],
        insetTop = offsetY,
        position = {
          width = rowWidth,
          height = self.cellHeight,
        },
        font = self.rowHeaderFont or self.headerFont,
      })
    end
  end

  self.cells = {}
  for i=1,self.numRows do
    tinsert(self.cells, i, {})
  end
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

function TableFrame:update()
  self.colHeight = #self.data * self.cellHeight + self.headerHeight
  for _,c in ipairs(self.cols) do
    c:height(self.colHeight)
  end
  for rowN,row in pairs(self.data) do
    if not self.cells[rowN] then tinsert(self.cells, rowN, {}) end -- make sure row exists
    for colN,data in pairs(row) do
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
          if data.onClick then cell.frame:SetScript("OnMouseUp", data.onClick) end
          if data.onEnter then cell.frame:SetScript("OnEnter", data.onEnter) end
          if data.onLeave then cell.frame:SetScript("OnLeave", data.onLeave) end
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
