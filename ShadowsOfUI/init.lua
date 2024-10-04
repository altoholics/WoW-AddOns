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
        {
          name = "RepBarEnabled",
          typ = "checkbox",
          default = true,
          table = function(db) return db.settings.repBars end,
          key = "enabled",
          label = "Rep bars enabled",
          tooltip = "Enable the rep bars at the bottmo of the screen",
        },
      },
    },
  },
}

function ns:settingChanged(var, name) --, setting
  ns.Print("setting changed", var, name)
end

function ns:onLoad()
  local maxLvl = self.wow.Player.isMaxLevel()
  if self.db.settings.xpBar and not maxLvl then
    self.xpBar = ns.ExpBar:new{}
  end
  if self.db.settings.repBars and maxLvl then
    self.repBars = ns.RepBarContainer:new{}
  end
end

ns.ui = LibNUI
