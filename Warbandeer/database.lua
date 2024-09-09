local addOnName, ns = ...
-- luacheck: globals WarbandeerDB

-- define the addon database and its defaults

local defaults = {
}

function ns.EventController:ADDON_LOADED(name)
  if addOnName == name then
    WarbandeerDB = WarbandeerDB or ns.g.CopyTable(defaults)
    self.db = WarbandeerDB
  end
end
ns.EventController:registerEvent("ADDON_LOADED")
