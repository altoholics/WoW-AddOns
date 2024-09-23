local _, ns = ...

local globals = {
  -- lua
  unpack = unpack,

  -- WoW lua extensions
  CopyTable = CopyTable,
  Mixin = Mixin, -- Interface/AddOns/Blizzard_SharedXMLBase/Mixin.lua#L6
  -- Interface/AddOns/Blizzard_SharedXMLBase/TableUtil.lua

  -- lua extensions
  CopyTables = ns.CopyTables,
  Generate = ns.Generate,
  MergeTable = ns.MergeTable,
  Select = ns.Select,
  Map = ns.Map,

  SlashCmdList = SlashCmdList,
  ShowOptionsCategory = InterfaceOptionsFrame_OpenToCategory,

  CreateColor = CreateColor,

  -- WoW API
  -- Bags / Inventory
  GetAverageItemLevel = GetAverageItemLevel,

  -- Class
  GetClassColor = C_ClassColor.GetClassColor,
  GetClassInfo = GetClassInfo, -- https://wowpedia.fandom.com/wiki/API_UnitClass
  NUM_CLASSES = GetNumClasses(),

  -- Expansions
  maxLevel = GetMaxLevelForPlayerExpansion(),

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

  -- Units
  UnitClassBase = UnitClassBase,
  UnitLevel = UnitLevel,
  UnitName = UnitName,
  UnitRace = UnitRace,
}

function ns.linkGlobals(addOn, g)
  addOn[g] = globals
end
