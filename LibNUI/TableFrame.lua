local _, ns = ...
local ui = ns.ui
local Class, Frame, BgFrame = ns.lua.Class, ui.Frame, ui.BgFrame

-- Creates an empty frame, but lays out its children in a tabular manner.
-- ops:
--   numCols?     int          - defaults to count of column names
--   numRows?     int          - defaults to count of row names
--   colNames?    string array - list of header names at top of columns
--   rowNames?    string array - list of header names at left of rows
--   CELL_WIDTH   int          - width of cells in pixels
--   CELL_HEIGHT  int          - height of cells in pixels

local TableRow = Class(BgFrame, function(o)
  o:topLeft(0, o.index * -o.frame:GetHeight() - o.insetTop)
  o:withLabel({
    text = o.label,
    position = {left = {2, 0}},
    template = o.font,
    color = o.color or {1, 1, 1, 1},
  })
end, {
  level = 2,
})

local TableCol = Class(BgFrame, function(o)
  o:topLeft(o.index * o.frame:GetWidth() + o.insetLeft, 0)
  o:withLabel({
    text = o.label,
    position = {
      topLeft = {},
      size = {o.frame:GetWidth(), o.headerHeight}
    },
    template = o.font,
    color = o.color or {1, 215/255, 0, 1},
    justifyH = "CENTER",
    justifyV = "MIDDLE",
  })
end, {
  level = 1,
})

-- making a table: https://www.wowinterface.com/forums/showthread.php?t=58670
local TableFrame = Class(Frame, function(o)
  o.numCols = o.numCols or (o.colNames and #o.colNames) or 0
  o.numRows = o.numRows or (o.rowNames and #o.rowNames) or 0

  local offsetX = o.rowNames ~= nil and o.CELL_WIDTH or 0
  local offsetY = o.colNames ~= nil and o.headerHeight or o.CELL_HEIGHT or 0

  o.cols = {}
  o.rows = {}

  if o.colNames then
    local colHeight = o.CELL_HEIGHT * (o.numRows) + (o.headerHeight or o.CELL_HEIGHT)
    for i=1,#o.colNames do
      o:addCol(o.colNames[i], o.CELL_WIDTH, colHeight, o.headerHeight or o.CELL_HEIGHT, offsetX, o.colHeaderFont or o.headerFont)
    end
  end

  if o.rowNames then
    local rowWidth = o.CELL_WIDTH * (o.numCols + 1)
    for i=1,#o.rowNames do
      o:addRow(o.rowNames[i], rowWidth, o.CELL_HEIGHT, offsetY, o.rowHeaderFont or o.headerFont)
    end
  end

  o.cells = {}
  for i=1,o.numRows do
    o.cells[i] = {}
  end
end)
ui.TableFrame = TableFrame

function TableFrame:addCol(text, width, height, headerHeight, insetLeft, font)
  table.insert(self.cols, TableCol:new{
    parent = self.frame,
    index = #self.cols,
    label = text,
    insetLeft = insetLeft,
    headerHeight = headerHeight,
    position = {
      width = width,
      height = height,
    },
    font = font,
    backdrop = {color = {0, 0, 0, math.fmod(#self.cols, 2) == 0 and 0.6 or 0.4}},
  })
end

function TableFrame:addRow(text, width, height, insetTop, font)
  table.insert(self.rows, TableRow:new{
    parent = self.frame,
    index = #self.rows,
    label = text,
    insetTop = insetTop,
    position = {
      width = width,
      height = height,
    },
    font = font,
  })
end

function TableFrame:row(n) return self.rows[n] end
function TableFrame:col(n) return self.cols[n] end
