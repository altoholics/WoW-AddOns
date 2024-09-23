local _, ns = ...

local globals = {
  unpack = unpack,
  CopyTable = CopyTable,

  SlashCmdList = SlashCmdList,
  ShowOptionsCategory = InterfaceOptionsFrame_OpenToCategory,

  NUM_CLASSES = GetNumClasses(),
  UnitName = UnitName,
  UnitLevel = UnitLevel,
  UnitClassBase = UnitClassBase,
  GetClassInfo = GetClassInfo, -- https://wowpedia.fandom.com/wiki/API_UnitClass
  GetClassColor = C_ClassColor.GetClassColor,
  CreateColor = CreateColor,
  maxLevel = GetMaxLevelForPlayerExpansion(),
  UnitRace = UnitRace,
  GetAverageItemLevel = GetAverageItemLevel,
  GetServerTime = GetServerTime,
  GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset,
  -- GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() - 604800
  -- if last recorded time <= GetServerTime(), do weekly reset
  RealmName = GetRealmName(),
  GetProfessions = GetProfessions,
  GetProfessionInfo = GetProfessionInfo,
}

function ns.linkGlobals(addOn, g)
  addOn[g] = globals
end
