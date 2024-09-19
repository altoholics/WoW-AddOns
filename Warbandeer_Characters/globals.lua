local _, ns = ...
-- luacheck: globals WarbandeerApi LibNUI

-- API between addon and the rest of ecosystem
-- This is the only file in the addon that should reference globals. This helps ensure that other files don't
-- accidentally create or reference globals in an inefficient manner.

ns.g = {
  unpack = unpack,
  CopyTable = CopyTable,
  SlashCmdList = SlashCmdList,
  ShowOptionsCategory = InterfaceOptionsFrame_OpenToCategory,
  UnitName = UnitName,
  UnitLevel = UnitLevel,
  UnitClassBase = UnitClassBase,
  GetClassInfo = GetClassInfo, -- https://wowpedia.fandom.com/wiki/API_UnitClass
  UnitRace = UnitRace,
  GetAverageItemLevel = GetAverageItemLevel,
  maxLevel = GetMaxLevelForPlayerExpansion(),
  GetServerTime = GetServerTime,
  GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset,
  -- GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() - 604800
  -- if last recorded time <= GetServerTime(), do weekly reset
  RealmName = GetRealmName(),
  GetProfessions = GetProfessions,
  GetProfessionInfo = GetProfessionInfo,
}

ns.ui = LibNUI

if not WarbandeerApi then
  -- not local, and thus global (shared)
  WarbandeerApi = {}
end
ns.api = WarbandeerApi


SLASH_WARBANDC1 = "/warbandc" -- luacheck: no global
SLASH_WARBANDC2 = "/wbc" -- luacheck: no global

function SlashCmdList.WARBANDC(msg) -- luacheck: no global
  ns:SlashCmd("WARBANDC", msg)
end
