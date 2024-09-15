local ADDON_NAME, ns = ...
-- luacheck: globals WarbandeerCharDB

-- define the addon database and its defaults

local CopyTable = ns.g.CopyTable

local defaults = {
  version = 1,
  characters = {}
}

function ns:ADDON_LOADED(name)
  if ADDON_NAME ~= name then return end
  WarbandeerCharDB = WarbandeerCharDB or CopyTable(defaults)
  if not WarbandeerCharDB.version then
    WarbandeerCharDB = CopyTable(defaults)
  end
  self.db = WarbandeerCharDB
end
ns:registerEvent("ADDON_LOADED")
