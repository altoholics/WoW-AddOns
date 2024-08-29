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

-- making a table: https://www.wowinterface.com/forums/showthread.php?t=58670
local TableFrame = Class(Frame, function(o)
    o.numCols = o.columns or #o.colNames
    o.numRows = o.numRows or #o.rowNames

    local offsetX = o.rowNames ~= nil and o.CELL_WIDTH or 0
    local offsetY = o.colNames ~= nil and o.CELL_HEIGHT or 0

    local frame = o.frame
    o.cols = {}
    o.rows = {}
    local cols, rows = o.cols, o.rows

    if o.colNames then
        local colHeight = o.CELL_HEIGHT * (o.numRows + 1)
        local col, h
        for i=1,#o.colNames do
            col = BgFrame:new{parent = frame, backdrop = {alpha = 0}}
            col:size(o.CELL_WIDTH, colHeight)
            col:topLeft(offsetX + (i-1) * o.CELL_WIDTH, 0)
            cols[i] = col

            h = col.frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            h:SetPoint("TOPLEFT", (i-1) * o.CELL_WIDTH, 0)
            h:SetText(o.colNames[i])
        end
    end

    if o.rowNames then
        local rowWidth = o.CELL_WIDTH * (o.numCols + 1)
        local row, h
        for i=1,#o.rowNames do
            row = BgFrame:new{parent = frame, backdrop = {alpha = 0}}
            row:size(rowWidth, o.CELL_HEIGHT)
            row:topLeft(0, (i-1) * -o.CELL_HEIGHT - offsetY)
            rows[i] = row

            h = row.frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            -- inset padding 2
            h:SetPoint("LEFT", 2, 0)
            h:SetText(o.rowNames[i])
        end
    end
end)
ui.TableFrame = TableFrame

function TableFrame:row(n) return self.rows[n] end
function TableFrame:col(n) return self.cols[n] end
