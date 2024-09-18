local ADDON_NAME, ns = ...
-- luacheck: globals WarbandeerCharDB

local CopyTable = ns.g.CopyTable

function ns:ADDON_LOADED(name)
  if ADDON_NAME ~= name then return end
  WarbandeerCharDB = WarbandeerCharDB or CopyTable(ns.Data.emptyDB)
  if not WarbandeerCharDB.version then -- if prior to versioning, reset
    WarbandeerCharDB = CopyTable(ns.Data.emptyDB)
  end
  self.db = WarbandeerCharDB
end
ns:registerEvent("ADDON_LOADED")
