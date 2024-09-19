local addOnName, ns = ...
-- any initial setup for the addon will go here
-- including some basic shared functions

function ns.Print(...) print("|cFF33FF99".. addOnName.. "|r:", ...) end

-- https://wowpedia.fandom.com/wiki/Category:HOWTOs
-- addon compartment, settings scroll templates: https://warcraft.wiki.gg/wiki/Patch_10.1.0/API_changes
-- settings changes: https://warcraft.wiki.gg/wiki/Patch_11.0.2/API_changes

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Options_Panel
ns.Colors = {
	white	= "|cFFFFFFFF",
	red = "|cFFFF0000",
	darkred = "|cFFF00000",
	green = "|cFF00FF00",
	orange = "|cFFFF7F00",
	yellow = "|cFFFFFF00",
	gold = "|cFFFFD700",
	teal = "|cFF00FF9A",
	cyan = "|cFF1CFAFE",
	lightBlue = "|cFFB0B0FF",
	battleNetBlue = "|cff82c5ff",
	grey = "|cFF909090",

	-- classes
	classMage = "|cFF69CCF0",
	classHunter = "|cFFABD473",

	-- recipes
	recipeGrey = "|cFF808080",
	recipeGreen = "|cFF40C040",
	recipeOrange = "|cFFFF8040",

	-- rarity : http://wow.gamepedia.com/Quality
	common = "|cFFFFFFFF",
	uncommon = "|cFF1EFF00",
	rare = "|cFF0070DD",
	epic = "|cFFA335EE",
	legendary = "|cFFFF8000",
	heirloom = "|cFFE6CC80",

	Alliance = "|cFF2459FF",
	Horde = "|cFFFF0000"
}

ns.Professions = {
  sl171 = {
    name = "Alchemy",
    skillLineID = 171,
    skillLineVariantID = 2871,
    spellID = 423321,
  },
  sl164 = {
    name = "Blacksmithing",
    skillLineID = 164,
    skillLineVariantID = 2872,
    spellID = 423332,
  },
  sl333 = {
    name = "Enchanting",
    skillLineID = 333,
    skillLineVariantID = 2874,
    spellID = 423334,
  },
  sl202 = {
    name = "Engineering",
    skillLineID = 202,
    skillLineVariantID = 2875,
    spellID = 423335,
  },
  sl182 = {
    name = "Herbalism",
    skillLineID = 182,
    skillLineVariantID = 2877,
    spellID = 441327,
  },
  sl773 = {
    name = "Inscription",
    skillLineID = 773,
    skillLineVariantID = 2878,
    spellID = 423338,
  },
  sl755 = {
    name = "Jewelcrafting",
    skillLineID = 755,
    skillLineVariantID = 2879,
    spellID = 423339,
  },
  sl165 = {
    name = "Leatherworking",
    skillLineID = 165,
    skillLineVariantID = 2880,
    spellID = 423340,
  },
  sl186 = {
    name = "Mining",
    skillLineID = 186,
    skillLineVariantID = 2881,
    spellID = 423341,
  },
  sl393 = {
    name = "Skinning",
    skillLineID = 393,
    skillLineVariantID = 2882,
    spellID = 423342,
  },
  sl197 = {
    name = "Tailoring",
    skillLineID = 197,
    skillLineVariantID = 2883,
    spellID = 423343,
  },
}
ns.api.professionInfo = ns.Professions

ns.api.ALLIANCE_RACES = {
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

ns.api.HORDE_RACES = {
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
raceIdToFactionIndex[85] = {14, true}

function ns.NormalizeRaceId(raceId)
  return ns.g.unpack(raceIdToFactionIndex[raceId])
end
