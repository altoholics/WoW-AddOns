local _, ns = ...

local lua = {
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
  ToMap = ns.ToMap,
  Class = ns.Class,
}

local wow = {
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

local wowui = {
  -- WoW FrameXML API
  CreateFrame = CreateFrame,
  ShowUIPanel = ShowUIPanel,
  HideUIPanel = HideUIPanel,
  UISpecialFrames = UISpecialFrames,
  UIParent = UIParent,

  Settings = Settings,
  StatusTrackingBarManager = StatusTrackingBarManager,
  BagsBar = BagsBar,
  MicroMenuContainer = MicroMenuContainer,
  MainMenuBar = MainMenuBar,
  MultiBarBottomLeft = MultiBarBottomLeft,
  MultiBarBottomRight = MultiBarBottomRight,
  MultiBarRight = MultiBarRight,
  MultiBarLeft = MultiBarLeft,
  MultiBar5 = MultiBar5,
  MultiBar6 = MultiBar6,
  MultiBar7 = MultiBar7,
  Tutorials = Tutorials,
}

function ns.linkGlobals(addOn, features)
  addOn[features.lua or "lua"] = lua
  addOn[features.wow or "wow"] = wow
  addOn[features.wowui or "wowui"] = wowui
end
