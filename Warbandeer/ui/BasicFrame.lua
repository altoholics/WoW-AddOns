local _, ns = ...

local ui = {}
ns.ui = ui

-- Basic frame classes.

local _G, setmetatable, tinsert, MergeTable = _G, setmetatable, tinsert, MergeTable
local CreateFrame, ShowUIPanel, Mixin = CreateFrame, ShowUIPanel, Mixin
local UISpecialFrames = UISpecialFrames

local function Class(parent, fn, defaults)
    local c = {}

    -- define the constructor
    function c:new(o)
        if defaults then MergeTable(o, defaults) end
        o = parent and parent:new(o) or (o or {})
        Mixin(o, parent or {}, c)
        setmetatable(o, self)
        self.__index = self
        fn(self, o)
        return o
    end

    return c
end
ui.Class = Class

-- empty frame
local Frame = Class(nil, function(self, o)
    o.frame = CreateFrame("Frame", o.name, o.parent, o.template)
    o.name = nil
    o.parent = nil
    o.template = nil
end)
ui.Frame = Frame

function Frame:center() self.frame:SetPoint("CENTER") end
function Frame:topLeft(x, y) self.frame:SetPoint("TOPLEFT", x, y) end
function Frame:bottomRight(x, y) self.frame:SetPoint("BOTTOMRIGHT", x, y) end
function Frame:size(x, y) self.frame:SetSize(x, y) end
function Frame:show() ShowUIPanel(self.frame) end
function Frame:makeDraggable()
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")
end

-- todo, resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames


-- frame with a background
local BgFrame = Class(Frame, function(self, o)
    o.bg = o.frame:CreateTexture()
    o.bg:SetAllPoints()
    o.bg:SetColorTexture(0, 0, 0, o.bgAlpha or 0.8)
end)
ui.BgFrame = BgFrame


-- dialog with title bar and close button, closable with escape
local Dialog = Class(Frame, function(self, o)
    local frame = o.frame
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)

    -- make it closable with Escape key
    _G[frame:GetName()] = frame -- put it in the global namespace
    tinsert(UISpecialFrames, frame:GetName()) -- make it a special frame

    -- set the title
    frame:SetTitle(self.title or frame:GetName())
end)
ui.Dialog = Dialog

function Dialog:makeTitlebarDraggable()
    self.frame.TitleContainer:SetScript("OnMouseDown", function()
        self.frame:StartMoving()
    end)
    self.frame.TitleContainer:SetScript("OnMouseUp", function()
        self.frame:StopMovingOrSizing()
    end)
end
