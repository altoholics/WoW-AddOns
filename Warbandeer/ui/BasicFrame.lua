local _, ns = ...

local ui = {}
ns.ui = ui

-- WARNING! Everything below is broken and still in flux.

-- Basic frame classes.

local CreateFrame, ShowUIPanel = CreateFrame, ShowUIPanel

-- empty frame
local Frame = {}
ui.Frame = Frame

function Frame:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    o.frame = CreateFrame("Frame", o.name, o.parent, o.template)
    o.name = nil
    o.parent = nil
    o.template = nil
    return o
end

function Frame:center() self.frame:SetPoint("CENTER") end
function Frame:size(x, y) self.frame:SetSize(x, y) end
function Frame:show() ShowUIPanel(self.frame) end
function Frame:makeDraggable()
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")
end

-- todo, resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames


-- frame with a background
local BgFrame = {}
ui.BgFrame = BgFrame

function BgFrame:new(o)
    o = Frame:new(o)
    setmetatable(o.__index, self)
    self.__index = self

    o.bg = o.frame:CreateTexture()
    o.bg:SetAllPoints()
    o.bg:SetColorTexture(0, 0, 0, 0.8)

    return o
end


-- dialog with title bar and close button, closable with escape
local Dialog = {}
ui.Dialog = Dialog

function Dialog:new(o)
    o = Frame:new(o)
    setmetatable(o.__index, self)
    self.__index = self

    local frame = o.frame
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    
    -- make it closable with Escape key
    _G[frame:GetName()] = frame -- put it in the global namespace
    tinsert(UISpecialFrames, frame:GetName()) -- make it a special frame

    -- set the title
    frame:SetTitle(self.title or frame:GetName())

    return o
end

function Dialog:makeTitlebarDraggable()
    self.frame.TitleContainer:SetScript("OnMouseDown", function()
        self.frame:StartMoving()
    end)
    self.frame.TitleContainer:SetScript("OnMouseUp", function()
        self.frame:StopMovingOrSizing()
    end)
end
