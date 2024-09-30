local _, ns = ...
-- luacheck: globals SlashCmdList InterfaceOptionsFrame_OpenToCategory GetAverageItemLevel C_ClassColor GetClassInfo
-- luacheck: globals GetNumClasses GetMaxLevelForPlayerExpansion GetProfessions GetProfessionInfo GetRealmName
-- luacheck: globals GetServerTime C_DateAndTime UnitClassBase UnitLevel UnitName UnitRace C_AddOns UnitXP UnitXPMax
-- luacheck: globals GetXPExhaustion GetRestState UnitExists UnitAffectingCombat GetFactionInfoByID C_MajorFactions
-- luacheck: globals C_WeeklyRewards C_Item LoadAddOn

ns.wow = {
  SlashCmdList = SlashCmdList,
  ShowOptionsCategory = InterfaceOptionsFrame_OpenToCategory,

  -- WoW API
  -- Bags / Inventory
  GetAverageItemLevel = GetAverageItemLevel,

  -- Class
  GetClassColor = C_ClassColor.GetClassColor,
  GetClassInfo = GetClassInfo, -- https://wowpedia.fandom.com/wiki/API_UnitClass
  NUM_CLASSES = GetNumClasses(),

  -- Expansions
  maxLevel = GetMaxLevelForPlayerExpansion(),

  -- Items
  GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo,

  -- Professions
  GetProfessions = GetProfessions,
  GetProfessionInfo = GetProfessionInfo,

  -- Realms
  RealmName = GetRealmName(),

  -- System / Date & Time
  GetServerTime = GetServerTime,
  GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset,
  -- GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() - 604800
  -- if last recorded time <= GetServerTime(), do weekly reset

  -- Weekly Rewards
  GetActivities = C_WeeklyRewards.GetActivities,
  GetExampleRewardItemHyperlinks = C_WeeklyRewards.GetExampleRewardItemHyperlinks,

  -- Units
  UnitClassBase = UnitClassBase,
  UnitLevel = UnitLevel,
  UnitName = UnitName,
  UnitRace = UnitRace,

  LoadAddOn = LoadAddOn,
  IsAddOnLoaded = C_AddOns.IsAddOnLoaded,
  UnitXP = UnitXP,
  UnitXPMax = UnitXPMax,
  GetXPExhaustion = GetXPExhaustion,
  GetRestState = GetRestState,
  UnitExists = UnitExists,
  UnitAffectingCombat = UnitAffectingCombat,
  GetFactionInfoByID = GetFactionInfoByID,
  GetMajorFactionRenownInfo = C_MajorFactions.GetMajorFactionRenownInfo,
}

ns.wow.Player = {}
function ns.wow.Player.name() return UnitName("player") end
function ns.wow.Player.level() return UnitLevel("player") end

ns.wow.GreatVault = {}
function ns.wow.GreatVault.getRewardOptions()
  local rewards = {}
  local counts = {}
  local best = 0
  local bestN = 0
  -- https://wowpedia.fandom.com/wiki/API_C_WeeklyRewards.GetActivities
  local activities = ns.wow.GetActivities()
  for _,activity in ipairs(activities) do
    if activity.progress >= activity.threshold then
      local link = ns.wow.GetExampleRewardItemHyperlinks(activity.id)
      if link then
        local ilvl = ns.wow.GetDetailedItemLevelInfo(link)
        if not counts[ilvl] then
          counts[ilvl] = 1
        else
          counts[ilvl] = counts[ilvl] + 1
        end
        if ilvl > best then
          best = ilvl
          bestN = 1
        elseif ilvl == best then
          bestN = bestN + 1
        end
      end
    end
  end
  return rewards, counts, best, bestN
end

-- type 1 dungeon
-- type 3 raid
-- type 6 delves / world events

-- activityTierID 9 is Tier 1 world event

-- C_WeeklyRewards.GetActivityEncounterInfo(3,1) -- raid box 1
-- -> { {uiOrder, bestDifficulty, instanceID, encounterID}, ... }
-- uiOrder 1-8 (seems to be in reverse order of this)
-- bestDifficulty 17 is LFR (for 584 gear) - 3 with best difficulty > 0 means 3 bosses down
-- EJ_GetInstanceInfo(instanceID) e.g. 1273
-- -> name, desc, bgImageID, btnImageID, loreImgID, btnImg2ID, dungeonMapID, journalLink, shouldDisplayDifficulty, mapID, bool
-- https://wowpedia.fandom.com/wiki/API_EJ_GetInstanceInfo
-- https://wowpedia.fandom.com/wiki/API_EJ_GetEncounterInfo
-- EJ_GetEncounterInfo(encounterID) e.g. 2607
-- -> name, description, journalEncounterID, rootSectionID, link, journalInstanceID, dungeonEncounterID, instanceID

-- LoadAddOn("Blizzard_WeeklyRewards"); WeeklyRewardsFrame:Show()

-- https://github.com/Gethe/wow-ui-source/blob/2e827a602452a4d90608d3aba54f2e037a00e36a/Interface/AddOns/Blizzard_WeeklyRewards/Blizzard_WeeklyRewards.lua

-- ilvl = C_Item.GetDetailedItemLevelInfo(C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id))
