local _, ns = ...
-- luacheck: globals InterfaceOptionsFrame_OpenToCategory GetAverageItemLevel C_ClassColor GetClassInfo
-- luacheck: globals GetNumClasses GetMaxLevelForPlayerExpansion GetRealmName GetItemCooldown
-- luacheck: globals GetServerTime C_DateAndTime UnitLevel UnitName UnitRace C_AddOns
-- luacheck: globals UnitExists UnitAffectingCombat GetSpellInfo GetChannelName GetTime
-- luacheck: globals C_WeeklyRewards C_Item LoadAddOn C_Spell DoEmote SendChatMessage

local wow = {
  -- WoW API
  -- Bags / Inventory
  GetAverageItemLevel = GetAverageItemLevel,

  -- Chat
  GetChannelName = GetChannelName,
  SendChatMessage = SendChatMessage,

  -- Class
  GetClassColor = C_ClassColor.GetClassColor,
  GetClassInfo = GetClassInfo, -- https://wowpedia.fandom.com/wiki/API_UnitClass
  NUM_CLASSES = GetNumClasses(),

  -- Expansions
  maxLevel = GetMaxLevelForPlayerExpansion(),

  -- Items
  GetItemCooldown = GetItemCooldown,
  GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo,

  -- Realms
  RealmName = GetRealmName(),

  -- Spells
  GetSpellName = function(id)
    return C_Spell.GetSpellInfo(id).name
  end,
  GetSpellTexture = C_Spell.GetSpellTexture,

  -- System
  DoEmote = DoEmote,
  -- System / Date & Time
  GetServerTime = GetServerTime,
  GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset,
  -- GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() - 604800
  -- if last recorded time <= GetServerTime(), do weekly reset
  GetTime = GetTime,

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
