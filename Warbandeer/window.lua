local addOnName, ns = ...

-- set up the main addon window

local ui = LibNUI
local PortraitFrame, TableFrame = ui.PortraitFrame, ui.TableFrame

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
    local pf = PortraitFrame:new{
        name = addOnName,
        portraitPath = "Interface\\Icons\\inv_10_tailoring2_banner_green.blp",
    }
    pf:center()
    pf:size(100 * (#ALLIANCE_RACES + 1) + 24, 400)
    
    -- add the contents
    local t = TableFrame:new{
        parent = pf.frame,
        CELL_WIDTH = 100,
        CELL_HEIGHT = 24,
        colNames = ALLIANCE_RACES,
        rowNames = CLASS_NAMES,
    }
    t:topLeft(12, -56)
    t:bottomRight(-58, 8)

    -- color the backgrounds of the rows by class color
    for i=1,NUM_CLASSES do
        t:row(i).bg:SetColorTexture(CLASSES[i].color.r, CLASSES[i].color.g, CLASSES[i].color.b, 0.2)
    end

    return pf
end

function ns.Open()
    if not ns.MainWindow then
        ns.MainWindow = CreateMainFrame()
    end

    ns.MainWindow:show()
end
