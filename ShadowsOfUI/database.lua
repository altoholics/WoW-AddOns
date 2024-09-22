local addOnName, ns = ...
-- luacheck: globals ShadowsOfUIDB

-- define the addon database and its defaults

local defaults = {
  settings = {
    xpBar = {
      enabled = true,
    },
    repBars = {
      enabled = true,
    },
  },
}

function ns.EventController:ADDON_LOADED(name)
  if addOnName == name then
    ShadowsOfUIDB = ShadowsOfUIDB or ns.g.CopyTable(defaults)
    ns.db = ShadowsOfUIDB
    if ns.registerSettings then ns:registerSettings() end
  end
end
ns.EventController:registerEvent("ADDON_LOADED")
