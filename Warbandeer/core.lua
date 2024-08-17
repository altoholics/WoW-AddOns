local addOnName, ns = ...

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

function ns.Open()
    -- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
    -- https://www.wowinterface.com/forums/showthread.php?t=40444
    local frame = CreateFrame("Frame", "Warbandeer", UIParent, "BasicFrameTemplateWithInset")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    frame:SetPoint("CENTER")
    frame:SetSize(200, 200)
    local tex = frame:CreateTexture("ARTWORK")
    tex:SetAllPoints()
    -- tex:SetColorTexture(1.0, 0.5, 0, 0.5)

    frame.TitleBg:SetHeight(30)
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOPLEFT", frame.TitleBg, "TOPLEFT", 5, -3)
    frame.title:SetText("Warbandeer")

    ShowUIPanel(frame)
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

SlashCmdList.WARBAND = function(msg, editBox)
    ns.Open()
end

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Options_Panel
