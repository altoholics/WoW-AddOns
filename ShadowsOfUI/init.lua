local ADDON_NAME, ns = ...
-- luacheck: globals LibNAddOn

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

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  db = {
    name = "ShadowsOfUIDB",
    defaults = defaults,
  },
}
