local _, ns = ...
-- luacheck: globals WarbandeerCharDB

-- define the addon database and its defaults

local defaults = {
  characters = {}
}

ns.onLoad(function()
  WarbandeerCharDB = WarbandeerCharDB or ns.g.CopyTable(defaults)
  ns.db = WarbandeerCharDB
end)
