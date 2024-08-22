local _, ns = ...
local ui = ns.ui

-- Creates a Portrait Frame, a default styled frame with textured background, border, close button,
-- title bar, and a large circular portrait in the top left.

local _G = _G
local CreateFrame, ShowUIPanel = CreateFrame, ShowUIPanel
local C_AddOns, UIParent, UISpecialFrames = C_AddOns, UIParent, UISpecialFrames

local function createFrame(ops)
    -- this gives us a full window with:
    --   a circle portrait in the top left
    --   a close button in the top right
    --   a title bar
    -- https://github.com/Gethe/wow-ui-source/blob/b5c546c1625c96fe008a771c5c46b4ccb90944f6/Interface/AddOns/Blizzard_SharedXML/PortraitFrame.lua
    local frame = CreateFrame("Frame", ops.name, UIParent, "PortraitFrameTemplate")
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    
    -- make it closable with Escape key
    _G[frame:GetName()] = frame -- put it in the global namespace
    tinsert(UISpecialFrames, frame:GetName()) -- make it a special frame

    -- set the title
    frame:SetTitle(ops.title or ops.name)

    -- make it draggable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    -- only use the title bar for dragging
    frame.TitleContainer:SetScript("OnMouseDown", function()
        frame:StartMoving()
    end)
    frame.TitleContainer:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
    end)

    -- portrait
    frame:SetPortraitTextureRaw(ops.portraitPath)

    -- todo, make resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames

    -- re-skin, if present
    if C_AddOns.IsAddOnLoaded(ops.name .. "_FrameColor") then
        ns.api.SkinFrame(frame)
    end

    return frame
end

local PortraitFrame = {}
ui.PortraitFrame = PortraitFrame
function PortraitFrame:create(name, portraitPath)
    local o = {
        name = name,
        portraitPath = portraitPath,
    }
    setmetatable(o, self)
    self.__index = self
    o.frame = createFrame(o)
    return o
end

-- position it on screen and size it
function PortraitFrame:position(point, width, height)
    self.frame:SetPoint(point)
    self.frame:SetSize(width, height)
end

function PortraitFrame:show()
    ShowUIPanel(self.frame)
end
