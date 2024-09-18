local _, ns = ...
local ui = ns.ui
local Class, Frame, BgFrame = ns.util.Class, ui.Frame, ui.BgFrame

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
    position = {ns.ui.edge.Left, 2, 0},
    template = o.font,
  })
end, {
  level = 2,
  backdrop = {alpha = 0},
})

local TableCol = Class(BgFrame, function(o)
  o:topLeft(o.index * o.frame:GetWidth() + o.insetLeft, 0)
  o:withLabel({
    text = o.label,
    position = {ns.ui.edge.TopLeft, 3, -6},
    template = o.font,
  })
  o.label:SetWidth(o.frame:GetWidth() - 6)
  o.label:SetJustifyH("CENTER")
  if o.label:GetNumLines() > 1 then
    o.label:SetPoint(ns.ui.edge.TopLeft, 3, 0)
  end
end, {
  level = 1,
  backdrop = {alpha = 0},
})

-- making a table: https://www.wowinterface.com/forums/showthread.php?t=58670
local TableFrame = Class(Frame, function(o)
  o.numCols = o.columns or #o.colNames
  o.numRows = o.numRows or #o.rowNames

  local offsetX = o.rowNames ~= nil and o.CELL_WIDTH or 0
  local offsetY = o.colNames ~= nil and o.CELL_HEIGHT or 0

  o.cols = {}
  o.rows = {}

  if o.colNames then
    local colHeight = o.CELL_HEIGHT * (o.numRows + 1)
    for i=1,#o.colNames do
      o:addCol(o.colNames[i], o.CELL_WIDTH, colHeight, offsetX, o.colHeaderFont or o.headerFont)
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

function TableFrame:addCol(text, width, height, insetLeft, font)
  table.insert(self.cols, TableCol:new{
    parent = self.frame,
    index = #self.cols,
    label = text,
    insetLeft = insetLeft,
    position = {
      width = width,
      height = height,
    },
    font = font,
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
