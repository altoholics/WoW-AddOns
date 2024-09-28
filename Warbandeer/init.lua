local ADDON_NAME, ns = ...
-- luacheck: globals LibNAddOn LibNUI WarbandeerApi

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  db = {
    name = "WarbandeerDB",
  },
  slashCommands = {
    warband = {"/warband", "/wb"},
  },
  compartmentFn = "Warbandeer_OnAddonCompartmentClick",
}

ns.ui = LibNUI
ns.views = {}

if not WarbandeerApi then
  -- not local, and thus global (shared)
  WarbandeerApi = {}
end
ns.api = WarbandeerApi

-- https://wowpedia.fandom.com/wiki/Category:HOWTOs
-- addon compartment, settings scroll templates: https://warcraft.wiki.gg/wiki/Patch_10.1.0/API_changes
-- settings changes: https://warcraft.wiki.gg/wiki/Patch_11.0.2/API_changes

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Options_Panel

local unpack, Generate, Map, Select = ns.lua.unpack, ns.lua.Generate, ns.lua.Map, ns.lua.Select
local GetClassInfo, GetClassColor = ns.wow.GetClassInfo, ns.wow.GetClassColor

-- class colors: https://wowpedia.fandom.com/wiki/Class_colors

ns.ALLIANCE_RACES = {
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
  "Earthen",
}

ns.HORDE_RACES = {
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
  "Earthen",
}

ns.CLASSES = Generate(
  function(i)
    local n, id = GetClassInfo(i)
    local c = GetClassColor(id)
    return {name = n, id = id, color = c}
  end,
  ns.wow.NUM_CLASSES
)
ns.CLASS_NAMES = Map(ns.CLASSES, Select("name"))

-- index, isAlliance
local raceIdToFactionIndex = {
  {1, true},
  {1, false},
  {2, true},
  {3, true},
  {2, false}, -- 5
  {3, false},
  {4, true},
  {4, false},
  {6, false},
  {5, false}, -- 10
  {5, true},
}
raceIdToFactionIndex[22] = {6, true}
raceIdToFactionIndex[25] = {7, true}
raceIdToFactionIndex[26] = {7, false}
raceIdToFactionIndex[27] = {8, false}
raceIdToFactionIndex[28] = {9, false}
raceIdToFactionIndex[29] = {8, true}
raceIdToFactionIndex[30] = {9, true}
raceIdToFactionIndex[31] = {11, false}
raceIdToFactionIndex[32] = {11, true}
raceIdToFactionIndex[34] = {10, true}
raceIdToFactionIndex[35] = {12, false}
raceIdToFactionIndex[36] = {10, false}
raceIdToFactionIndex[37] = {12, true}
raceIdToFactionIndex[52] = {13, true}
raceIdToFactionIndex[70] = {13, false}
raceIdToFactionIndex[84] = {14, false}
raceIdToFactionIndex[85] = {14, true}

function ns.NormalizeRaceId(raceId)
  return unpack(raceIdToFactionIndex[raceId])
end
