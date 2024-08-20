local addOnName, ns = ...

-- set up the main addon window

local _G = _G

-- Wow APIs
local CreateFrame = CreateFrame
local C_AddOns, UISpecialFrames = C_AddOns, UISpecialFrames

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

local function CreateMainFrame()
    -- this gives us a full window with:
    --   a circle portrait in the top left
    --   a close button in the top right
    --   a title bar
    local frame = CreateFrame("Frame", addOnName, UIParent, "PortraitFrameTemplate")

    -- make it closable with Escape key
    _G[frame:GetName()] = frame -- put it in the global namespace
    tinsert(UISpecialFrames, frame:GetName()) -- make it a special frame

    -- set the title
    frame.title = _G["WarbandeerTitleText"] -- retrieve the global component created by the frame template
    frame.title:SetText(addOnName)

    -- give the background texture
    local tex = frame:CreateTexture("ARTWORK")
    tex:SetAllPoints()

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
    WarbandeerPortrait:SetTexture("Interface\\Icons\\inv_10_tailoring2_banner_green.blp")

    -- todo, make resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames

    -- center it on screen and size it
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetPoint("CENTER")
    frame:SetSize(800, 240)
 
    -- re-skin, if present
    if C_AddOns.IsAddOnLoaded("Warbandeer_FrameColor") then
        ns.api.SkinFrame(frame)
    end

    return frame
end

function ns.Open()
    if not ns.frame then
        ns.frame = CreateMainFrame()
    end

    ShowUIPanel(ns.frame)
end
