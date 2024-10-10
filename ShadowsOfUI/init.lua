local ADDON_NAME, ns = ...
-- luacheck: globals LibNAddOn LibNUI

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  db = {
    name = "ShadowsOfUIDB",
    defaults = {
      version = 2,
      settings = {
        xpBar = {
          enabled = true,
          hideDefault = true,
        },
        repBars = {
          enabled = true,
        },
        blizz = {
          hideMicroMenu = true,
          hideBags = true,
        },
        actionBars = {
          enabled = false,
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
          tooltip = "Enable the rep bars at the bottom of the screen",
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
        {
          name = "HideMicroMenu",
          typ = "checkbox",
          default = true,
          table = function(db) return db.settings.blizz end,
          key = "hideMicroMenu",
          label = "Hide micro menu buttons",
          tooltip = "Hide micro menu buttons",
        },
        {
          name = "HideBags",
          typ = "checkbox",
          default = true,
          table = function(db) return db.settings.blizz end,
          key = "hideBags",
          label = "Hide bag buttons",
          tooltip = "Hide bar buttons",
        },
        {
          name = "ActionBarsEnabled",
          typ = "checkbox",
          default = true,
          table = function(db) return db.settings.actionBars end,
          key = "enabled",
          label = "Use replacement action bars",
          tooltip = "Enable the replacement action bars at",
        },
      },
    },
  },
}

function ns:MigrateDB()
  local db = self.db
  if not db.version then
    db.settings.xpBar.hideDefault = true
    db.settings.blizz = {
      hideMicroMenu = true,
      hideBags = true,
    }
    db.version = 1
  end
  if 1 == db.version then
    db.settings.actionBars = {
      enabled = false,
    }
    db.version = 2
  end
end

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
  if "HideMicroMenu" == name then
    ns.wowui.MicroMenuContainer:SetShown(not value)
  end
  if "HideBags" == name then
    ns.wowui.BagsBar:SetShown(not value)
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
  if self.db.settings.blizz.hideMicroMenu then
    ns.wowui.MicroMenuContainer:Hide()
  end
  if self.db.settings.blizz.hideBags then
    ns.wowui.BagsBar:Hide()
  end
  if self.db.settings.actionBars.enabled then
    ns.ActionBars:new{}
  end
end

ns.ui = LibNUI

-- Disable the reagent bag tutorial
-- /run HelpTip:HideAllSystem("TutorialReagentBag")
-- C_CVar.SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG, true)
-- C_CVar.SetCVar("professionToolSlotsExampleShown", 1)
-- C_CVar.SetCVar("professionAccessorySlotsExampleShown", 1)
