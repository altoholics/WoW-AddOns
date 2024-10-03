local ADDON_NAME, ns = ...
-- luacheck: globals LibNAddOn LibNUI

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  db = {
    name = "ShadowsOfUIDB",
    defaults = {
      settings = {
        xpBar = {
          enabled = true,
        },
        repBars = {
          enabled = true,
        },
      },
    },
  },
  settings = {
    {
      title = "Shadows of UI",
      fields = {
        {
          name = "XpBarEnabled",
          typ = "checkbox",
          default = true,
          table = function(db) return db.settings.xpBar end,
          key = "enabled",
          label = "XP Bar enabled",
          tooltip = "Enable the xp bar at the bottom of the screen",
        },
      }
    },
  },
}

function ns:settingChanged(var, name) --, setting
  ns.Print("setting changed", var, name)
end

ns.ui = LibNUI
