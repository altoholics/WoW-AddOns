local _, ns = ...
local ui = ns.ui
local Class, Dialog = ui.Class, ui.Dialog

-- Creates a Portrait Frame, a default styled frame with textured background, border, close button,
-- title bar, and a large circular portrait in the top left.

local C_AddOns, UIParent = C_AddOns, UIParent

-- this gives us a full window with:
--   a circle portrait in the top left
--   a close button in the top right
--   a title bar
-- https://github.com/Gethe/wow-ui-source/blob/b5c546c1625c96fe008a771c5c46b4ccb90944f6/Interface/AddOns/Blizzard_SharedXML/PortraitFrame.lua

local PortraitFrame = Class(Dialog, function(self, o)
    o:makeDraggable()
    o:makeTitlebarDraggable()

    -- portrait
    local frame = o.frame
    frame:SetPortraitTextureRaw(o.portraitPath)

    -- re-skin, if present
    if C_AddOns.IsAddOnLoaded(frame:GetName() .. "_FrameColor") then
        ns.api.SkinFrame(frame)
    end
end, {
    parent = UIParent,
    template = "PortraitFrameTemplate"
})
ui.PortraitFrame = PortraitFrame
