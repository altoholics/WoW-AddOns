local addOnName, ns = ...
local ui = ns.ui
local PortraitFrame, TableFrame = ui.PortraitFrame, ui.TableFrame

-- set up the main addon window

-- Wow APIs
local NUM_CLASSES = GetNumClasses()
local GetClassInfo, GetClassColor = GetClassInfo, C_ClassColor.GetClassColor

local Generate, Map, Select = ns.util.Generate, ns.util.Map, ns.util.Select

-- class colors: https://wowpedia.fandom.com/wiki/Class_colors

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

local CLASSES = Generate(function(i) local n, id = GetClassInfo(i); local c = GetClassColor(id); return {name = n, id = id, color = c} end, NUM_CLASSES)
local CLASS_NAMES = Map(CLASSES, Select("name"))

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

local function CreateMainFrame()
    local frame = PortraitFrame:create(addOnName, "Interface\\Icons\\inv_10_tailoring2_banner_green.blp")
    frame:position("CENTER", 100 * (#ALLIANCE_RACES + 1) + 24, 400)

    -- add the contents
    local t = TableFrame:create(frame.frame, {
        CELL_WIDTH = 100,
        CELL_HEIGHT = 24,
        columnNames = ALLIANCE_RACES,
        rowNames = CLASS_NAMES,
    })
    t:position("TOPLEFT", nil, nil, 12, -56)
    t:position("BOTTOMRIGHT", nil, nil, -58, 8)

    -- color the backgrounds of the rows by class color
    for i=1,NUM_CLASSES do
        local r = t.frame.rows[i]
        r.bg = r:CreateTexture()
        r.bg:SetAllPoints()
        r.bg:SetColorTexture(CLASSES[i].color.r, CLASSES[i].color.g, CLASSES[i].color.b, 0.2)
    end

    return frame
end

function ns.Open()
    if not ns.MainWindow then
        ns.MainWindow = CreateMainFrame()
    end

    ns.MainWindow:show()
end
