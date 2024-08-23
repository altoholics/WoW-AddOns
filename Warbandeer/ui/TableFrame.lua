local _, ns = ...
local ui = ns.ui
local Frame = ui.Frame

-- Creates an empty frame, but lays out its children in a tabular manner.
-- ops:
--   numColumns?  int          - defaults to count of column names
--   numRows?     int          - defaults to count of row names
--   columnNames? string array - list of header names at top of columns
--   rowNames?    string array - list of header names at left of rows
--   CELL_WIDTH   int          - width of cells in pixels
--   CELL_HEIGHT  int          - height of cells in pixels

local CreateFrame = CreateFrame

-- making a table: https://www.wowinterface.com/forums/showthread.php?t=58670
local TableFrame = {}
ui.TableFrame = TableFrame
function TableFrame:new(o)
    o = Frame:new(o)
    Mixin(o, Frame, TableFrame)
    setmetatable(o, self)
    self.__index = self

    o.numColumns = o.columns or #o.columnNames
    o.numRows = o.numRows or #o.rowNames

    local offsetX = o.rowNames ~= nil and o.CELL_WIDTH or 0
    local offsetY = o.columnNames ~= nil and o.CELL_HEIGHT or 0
    
    local frame = o.frame

    if o.columnNames then
        local header = CreateFrame("Frame", nil, frame)
        frame.header = header
        header:SetSize(o.CELL_WIDTH * o.numColumns, o.CELL_HEIGHT)
        header:SetPoint("TOPLEFT", offsetX, 0)
        header.columns = {}

        local f
        for i=1,#o.columnNames do
            f = header:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            f:SetPoint("LEFT", (i-1) * o.CELL_WIDTH, 0)
            f:SetText(o.columnNames[i])
            header.columns[i] = f
        end
    end

    if o.rowNames then
        offsetX = o.CELL_WIDTH
        frame.rows = {}
        local rowWidth = o.CELL_WIDTH * (o.numColumns + 1)
        local row, h
        for i=1,#o.rowNames do
            row = CreateFrame("Frame", nil, frame)
            row:SetSize(rowWidth, o.CELL_HEIGHT)
            row:SetPoint("TOPLEFT", 0, (i-1) * -o.CELL_HEIGHT - offsetY)
            frame.rows[i] = row

            h = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            -- inset padding 2
            h:SetPoint("LEFT", 2, 0)
            h:SetText(o.rowNames[i])
        end
    end

    return o
end
