local addOnName, ns = ...

-- set up the main addon window

local _G = _G

-- Wow APIs
local CreateFrame = CreateFrame
local C_AddOns, UISpecialFrames = C_AddOns, UISpecialFrames

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
    frame:SetSize(800, 400)
 
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
    content.rows = {}
    local CELL_WIDTH = 100
    local CELL_HEIGHT = 24
    local NUM_CELLS = 12
    for i,c in pairs(CLASSES) do
        if not content.rows[i] then
            local button = CreateFrame("Button", nil, content)
            button:SetSize(CELL_WIDTH * NUM_CELLS, CELL_HEIGHT)
            button:SetPoint("TOPLEFT", 0, -i * CELL_HEIGHT)
            button.columns = {}
            button.columns[1] = button:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            button.columns[1]:SetPoint("LEFT", 0 * CELL_WIDTH, 0)
            content.rows[i] = button
        end
        content.rows[i].columns[1]:SetText(c)
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
