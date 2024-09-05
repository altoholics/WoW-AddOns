local _, ns = ...
-- luacheck: globals WarbandeerApi LibNUI

-- API between addon and the rest of ecosystem
-- This is the only file in the addon that should reference globals. This helps ensure that other files don't
-- accidentally create or reference globals in an inefficient manner.

ns.g = {
  unpack = unpack,
  NUM_CLASSES = GetNumClasses(),
  CopyTable = CopyTable,
  SlashCmdList = SlashCmdList,
  ShowOptionsCategory = InterfaceOptionsFrame_OpenToCategory,
  UnitName = UnitName,
  UnitLevel = UnitLevel,
  UnitClassBase = UnitClassBase,
  GetClassInfo = GetClassInfo, -- https://wowpedia.fandom.com/wiki/API_UnitClass
  GetClassColor = C_ClassColor.GetClassColor,
}

ns.ui = LibNUI

if not WarbandeerApi then
  -- not local, and thus global (shared)
  WarbandeerApi = {}
end
ns.api = WarbandeerApi


SLASH_WARBAND1 = "/warband" -- luacheck: no global
SLASH_WARBAND2 = "/wb" -- luacheck: no global

function SlashCmdList.WARBAND(msg) -- luacheck: no global
  ns:SlashCmd("WARBAND", msg)
end
