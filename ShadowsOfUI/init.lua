local ADDON_NAME, ns = ...
-- luacheck: globals LibNAddOn LibNUI

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  db = {
    name = "ShadowsOfUIDB",
    defaults = {
      version = 1,
      settings = {
        xpBar = {
          enabled = true,
          hideDefault = true,
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
        {
          name = "HideDefaultXPBar",
          typ = "checkbox",
          default = true,
          table = function(db) return db.settings.xpBar end,
          key = "hideDefault",
          label = "Hide default XP bar",
          tooltip = "Hide default Blizzard XP bar",
        },
      },
    },
  },
}

function ns:settingChanged(var, value, name) --, setting
  if "XpBarEnabled" == name then
    if value and self.xpBar then
      self.xpBar:hide()
    else
      self.xpBar = self.ExpBar:new{}
      self.xpBar:PLAYER_ENTERING_WORLD(false, true)
    end
  end
  if "HideDefaultXPBar" == name then
    ns.wowui.StatusTrackingBarManager:SetShown(not value)
  end
end

function ns:onLoad()
  local maxLvl = self.wow.Player:isMaxLevel()
  if self.db.settings.xpBar.enabled and not maxLvl then
    self.xpBar = ns.ExpBar:new{}
  end
  if self.db.settings.repBars.enabled and maxLvl then
    self.repBars = ns.RepBarContainer:new{}
  end
  if self.db.settings.xpBar.hideDefault then
    ns.wowui.StatusTrackingBarManager:Hide()
  end
end

ns.ui = LibNUI
