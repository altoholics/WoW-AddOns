local _, ns = ...
local ui = ns.ui

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
local function createFrame(parent, ops)
    ops.numColumns = ops.columns or #ops.columnNames
    ops.numRows = ops.numRows or #ops.rowNames

    local frame = CreateFrame("Frame", nil, parent)
    local offsetX = ops.rowNames ~= nil and ops.CELL_WIDTH or 0
    local offsetY = ops.columnNames ~= nil and ops.CELL_HEIGHT or 0

    if ops.columnNames then
        local header = CreateFrame("Frame", nil, frame)
        frame.header = header
        header:SetSize(ops.CELL_WIDTH * ops.numColumns, ops.CELL_HEIGHT)
        header:SetPoint("TOPLEFT", offsetX, 0)
        header.columns = {}

        local f
        for i=1,#ops.columnNames do
            f = header:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            f:SetPoint("LEFT", (i-1) * ops.CELL_WIDTH, 0)
            f:SetText(ops.columnNames[i])
            header.columns[i] = f
        end
    end

    if ops.rowNames then
        offsetX = ops.CELL_WIDTH
        frame.rows = {}
        local rowWidth = ops.CELL_WIDTH * (ops.numColumns + 1)
        local row, h
        for i=1,#ops.rowNames do
            row = CreateFrame("Frame", nil, frame)
            row:SetSize(rowWidth, ops.CELL_HEIGHT)
            row:SetPoint("TOPLEFT", 0, (i-1) * -ops.CELL_HEIGHT - offsetY)
            frame.rows[i] = row

            h = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            -- inset padding 2
            h:SetPoint("LEFT", 2, 0)
            h:SetText(ops.rowNames[i])
        end
    end

    return frame
end

local TableFrame = {}
function TableFrame:create(parent, ops)
    local o = ops or {}
    setmetatable(o, self)
    self.__index = self
    o.frame = createFrame(parent, o)
    return o
end

-- position it on screen and size it
function TableFrame:position(point, width, height, offx, offy)
    self.frame:SetPoint(point, offx, offy)
    if width ~= nil and height ~= nil then self.frame:SetSize(width, height) end
end

function TableFrame:show()
    ShowUIPanel(self.frame)
end

ui.TableFrame = TableFrame
