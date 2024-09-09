local _, ns = ...
local ui = ns.ui
local Class, Dialog = ns.util.Class, ui.Dialog

-- Creates a Portrait Frame, a default styled frame with textured background, border, close button,
-- title bar, and a large circular portrait in the top left.

local IsAddOnLoaded, UIParent = ns.g.IsAddOnLoaded, ns.g.UIParent

-- this gives us a full window with:
--   a circle portrait in the top left
--   a close button in the top right
--   a title bar
local PortraitFrame = Class(Dialog, function(o)
    o:makeDraggable()
    o:makeTitlebarDraggable()

    -- portrait
    local frame = o.frame
    frame:SetPortraitTextureRaw(o.portraitPath)

    -- re-skin, if present
    if IsAddOnLoaded("FrameColor") then
        ns.SkinFrame(frame)
    end
end, {
    parent = UIParent,
    -- Interface/AddOns/Blizzard_SharedXML/PortraitFrame.lua
    template = "PortraitFrameTemplate"
})
ui.PortraitFrame = PortraitFrame
