local _, ns = ...
-- luacheck: globals InterfaceOptionsFrame_OpenToCategory GetAverageItemLevel C_ClassColor GetClassInfo
-- luacheck: globals GetNumClasses GetMaxLevelForPlayerExpansion GetRealmName
-- luacheck: globals GetServerTime C_DateAndTime UnitLevel UnitName UnitRace C_AddOns
-- luacheck: globals UnitExists UnitAffectingCombat
-- luacheck: globals C_WeeklyRewards C_Item LoadAddOn

local wow = {
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
  UnitLevel = UnitLevel,
  UnitName = UnitName,
  UnitRace = UnitRace,

  LoadAddOn = C_AddOns.LoadAddOn,
  IsAddOnLoaded = C_AddOns.IsAddOnLoaded,
  UnitExists = UnitExists,
  UnitAffectingCombat = UnitAffectingCombat,
}
ns.wow = wow
