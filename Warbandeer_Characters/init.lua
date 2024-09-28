local ADDON_NAME, ns = ...
-- luacheck: globals LibNAddOn Mixin LibNUI WarbandeerApi

local Data = {}
ns.Data = Data

Data.dbVersion = 3
local emptyDB = {
  version = Data.dbVersion,
  numCharacters = 0,
  characters = {},
}

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  db = {
    name = "WarbandeerCharDB",
    defaults = emptyDB,
  },
  slashCommands = {
    warbandc = {"/warbandc", "/wbc"},
  },
}

ns.ui = LibNUI

if not WarbandeerApi then
  -- not local, and thus global (shared)
  WarbandeerApi = {}
end
ns.api = WarbandeerApi

Data.emptyCharacter = {
  name = "",
  classId = "",
  className = "",
  level = 0,
  race = "",
  raceId = -1,
  ilvl = 0,
}

local characterMT = {
  __lt = function(c1, c2)
    return c1.level >= c2.level and c1.ilvl >= c2.ilvl and c1.name > c2.name
  end
}

function Data.newCharacter()
  local c = ns.lua.CopyTable(Data.emptyCharacter)
  setmetatable(c, characterMT)
  return c
end

function ns:MigrateDB()
  local db = ns.db
  local version = db.version
  if not version then
    Mixin(db, emptyDB)
    return
  end
  if version == 1 then
    local n = 0
    for _ in pairs(db.characters) do n = n + 1 end
    db.numCharacters = n
    db.version = 2
  end
  if version == 2 then
    for _,t in pairs(db.characters) do
      if t.ralm then
        t.realm = t.ralm
        t.ralm = nil
      end
      if t.raceId then
        local raceIndex, isAlliance = ns.NormalizeRaceId(t.raceId)
        t.raceIdx = raceIndex
        t.isAlliance = isAlliance
      end
    end
    db.version = 3
  end
end

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
raceIdToFactionIndex[84] = {14, false}
raceIdToFactionIndex[85] = {14, true}

function ns.NormalizeRaceId(raceId)
  return unpack(raceIdToFactionIndex[raceId])
end

--[[
https://warcraft.wiki.gg/wiki/World_of_Warcraft_API

C_WeeklyRewards
C_WeeklyRewards.AreRewardsForCurrentRewardPeriod() : isCurrentPeriod
C_WeeklyRewards.CanClaimRewards() : canClaimRewards
C_WeeklyRewards.ClaimReward(id)
C_WeeklyRewards.CloseInteraction()
C_WeeklyRewards.GetActivities([type]) : activities
C_WeeklyRewards.GetActivityEncounterInfo(type, index) : info
C_WeeklyRewards.GetConquestWeeklyProgress() : weeklyProgress
C_WeeklyRewards.GetDifficultyIDForActivityTier(activityTierID) : difficultyID
C_WeeklyRewards.GetExampleRewardItemHyperlinks(id) : hyperlink, upgradeHyperlink
C_WeeklyRewards.GetItemHyperlink(itemDBID) : hyperlink
C_WeeklyRewards.GetNextActivitiesIncrease(activityTierID, level) : hasSeasonData, nextActivityTierID, nextLevel, itemLevel
C_WeeklyRewards.GetNextMythicPlusIncrease(mythicPlusLevel) : hasSeasonData, nextMythicPlusLevel, itemLevel
C_WeeklyRewards.GetNumCompletedDungeonRuns() : numHeroic, numMythic, numMythicPlus
C_WeeklyRewards.HasAvailableRewards() : hasAvailableRewards
C_WeeklyRewards.HasGeneratedRewards() : hasGeneratedRewards
C_WeeklyRewards.HasInteraction() : isInteracting
C_WeeklyRewards.IsWeeklyChestRetired() : isRetired
C_WeeklyRewards.OnUIInteract()
C_WeeklyRewards.ShouldShowFinalRetirementMessage() : showRetirementMessage
C_WeeklyRewards.ShouldShowRetirementMessage() : showRetirementMessage
]]
