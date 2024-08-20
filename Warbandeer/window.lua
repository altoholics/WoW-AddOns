local addOnName, ns = ...

-- set up the main addon window

local _G = _G

-- Wow APIs
local CreateFrame = CreateFrame
local C_AddOns, UISpecialFrames = C_AddOns, UISpecialFrames

-- class colors: https://wowpedia.fandom.com/wiki/Class_colors
local CLASSES = {
    "Warrior",
    "Hunter",
    "Mage",
    "Rogue",
    "Priest",
    "Warlock",
    "Paladin",
    "Druid",
    "Shaman",
    "Monk",
    "Demon Hunter",
    "Death Knight",
    "Evoker",
}

local ALLIANCE_RACES = {
    "Human",
    "Dwarf",
    "Night Elf",
    "Gnome",
    "Draenei",
    "Worgen",
    "Pandaren",
    "Void Elf",
    "Lightforged Draenei",
    "Dark Iron Dwarf",
    "Kul Tiran",
    "Mechagnome",
    "Dracthyr",
}

local HORDE_RACES = {
    "Orc",
    "Undead",
    "Tauren",
    "Troll",
    "Blood Elf",
    "Goblin",
    "Pandaren",
    "Nightborne",
    "Highmountain Tauren",
    "Mag'har Orc",
    "Zandalari Troll",
    "Vulpera",
    "Dracthyr",
}

local CELL_WIDTH = 100
local CELL_HEIGHT = 24
local NUM_CELLS = 12

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

local function CreateMainFrame()
    -- this gives us a full window with:
    --   a circle portrait in the top left
    --   a close button in the top right
    --   a title bar
    -- https://github.com/Gethe/wow-ui-source/blob/b5c546c1625c96fe008a771c5c46b4ccb90944f6/Interface/AddOns/Blizzard_SharedXML/PortraitFrame.lua
    local frame = CreateFrame("Frame", addOnName, UIParent, "PortraitFrameTemplate")

    -- make it closable with Escape key
    _G[frame:GetName()] = frame -- put it in the global namespace
    tinsert(UISpecialFrames, frame:GetName()) -- make it a special frame

    -- set the title
    frame:SetTitle(addOnName)

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
    frame:SetPortraitTextureRaw("Interface\\Icons\\inv_10_tailoring2_banner_green.blp")

    -- todo, make resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames

    -- center it on screen and size it
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetPoint("CENTER")
    frame:SetSize(CELL_WIDTH * (#ALLIANCE_RACES + 1) + 24, 400)
 
    -- re-skin, if present
    if C_AddOns.IsAddOnLoaded("Warbandeer_FrameColor") then
        ns.api.SkinFrame(frame)
    end

    -- add the contents
    -- making a table: https://www.wowinterface.com/forums/showthread.php?t=58670
    frame.tableFrame = CreateFrame("Frame", nil, frame)
    frame.tableFrame:SetPoint("TOPLEFT", 12, -56)
    frame.tableFrame:SetPoint("BOTTOMRIGHT", -58, 8)
    local content = frame.tableFrame

    local ROW_WIDTH = CELL_WIDTH * (#ALLIANCE_RACES + 1)

    content.header = CreateFrame("Frame", nil, content)
    content.header:SetSize(ROW_WIDTH, CELL_HEIGHT)
    content.header:SetPoint("TOPLEFT", 0, 0)

    content.header.columns = {}
    for i=1,#ALLIANCE_RACES do
        content.header.columns[i] = content.header:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        content.header.columns[i]:SetPoint("LEFT", i * CELL_WIDTH, 0)
        content.header.columns[i]:SetText(ALLIANCE_RACES[i])
    end
    
    content.rows = {}
    for i=1,GetNumClasses() do
        local className, classFile = GetClassInfo(i)
        local classColor = C_ClassColor.GetClassColor(classFile)
        if not content.rows[i] then
            local row = CreateFrame("Frame", nil, content)
            row:SetSize(ROW_WIDTH, CELL_HEIGHT)
            row:SetPoint("TOPLEFT", 0, -i * CELL_HEIGHT)
            row.tex = row:CreateTexture()
            row.tex:SetAllPoints()
            row.tex:SetColorTexture(classColor.r, classColor.g, classColor.b, 0.5)
            
            row.columns = {}
            row.columns[1] = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            row.columns[1]:SetPoint("LEFT", 0 * CELL_WIDTH, 0)
            content.rows[i] = row
        end
        content.rows[i].columns[1]:SetText(className)
        content.rows[i].columns[1]:Show()
    end

    return frame
end

function ns.Open()
    if not ns.MainWindow then
        ns.MainWindow = CreateMainFrame()
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    ShowUIPanel(ns.MainWindow)
end
