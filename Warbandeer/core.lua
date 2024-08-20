local addOnName, ns = ...
local _G = _G

-- WoW APIs
local CreateFrame, SlashCmdList, UISpecialFrames = CreateFrame, SlashCmdList, UISpecialFrames

function ns.Print(...) print("|cFF33FF99".. addOnName.. "|r:", ...) end

local f = CreateFrame("Frame")
function f:OnEvent(event, ...)
    if self[event] then
        self[event](self, event, ...)
    end
end
f:SetScript("OnEvent", f.OnEvent)

-- https://wowpedia.fandom.com/wiki/Category:HOWTOs
-- addon compartment, settings scroll templates: https://warcraft.wiki.gg/wiki/Patch_10.1.0/API_changes
-- settings changes: https://warcraft.wiki.gg/wiki/Patch_11.0.2/API_changes

function ns.CreateMainFrame()
    -- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
    -- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444
    ns.frame = CreateFrame("Frame", addOnName, UIParent, "PortraitFrameTemplate")
    local frame = ns.frame

    -- make it closable with Escape key
    _G[frame:GetName()] = frame
    tinsert(UISpecialFrames, frame:GetName())

    local r,g,b = PANEL_BACKGROUND_COLOR:GetRGB()
    frame.Bg:SetColorTexture(r,g,b,0.9)

    -- set the title
    frame.title = _G["WarbandeerTitleText"]
    frame.title:SetText(addOnName)

    -- make it draggable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
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
    local tex = frame:CreateTexture("ARTWORK")
    tex:SetAllPoints()

    -- re-skin, if present
    if C_AddOns.IsAddOnLoaded("Warbandeer_FrameColor") and ns.api then
        ns.api.SkinFrame(frame)
    end
end

function ns.Open()
    if not ns.frame then
        ns.CreateMainFrame()
    end

    ShowUIPanel(ns.frame)
end

local defaults = {
}

function f:ADDON_LOADED(event, name)
    if addOnName == name then
        self.db = WarbandeerDB or CopyTable(defaults)
    end
end
f:RegisterEvent("ADDON_LOADED")

function f:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
    -- false/false when transitioning (portal, etc)
    -- ns.Print(event, isLogin, isReload)
    -- on isLogin, scan character info?
end
f:RegisterEvent("PLAYER_ENTERING_WORLD")

function Warbandeer_OnAddonCompartmentClick(addonName, buttonName)
    ns.Print("OnAddonCompartmentClick", addonName, buttonName)
    ns.Open()
end

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Slash_commands
SLASH_WARBAND1 = "/warband"
SLASH_WARBAND2 = "/wb"

function SlashCmdList.WARBAND(msg)
    ns.Open()
end

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Options_Panel
