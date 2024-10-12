local ADDON_NAME, ns = ...
-- luacheck: globals LibNAddOn LibNUI

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  db = {
    name = "ShadowsOfUIDB",
    defaults = {
      version = 4,
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
          hidePlayerFrame = false,
          hideTargetFrame = false,
        },
        actionBars = {
          enabled = false,
        },
        hud = {
          enabled = false,
        },
        chat = {
          enabled = false,
        },
        command = {
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
          label = "Use XP Bar",
          tooltip = "Enable the xp bar at the bottom of the screen",
        },
        {
          name = "RepBarEnabled",
          typ = "checkbox",
          default = true,
          table = function(db) return db.settings.repBars end,
          key = "enabled",
          label = "Use Rep bars",
          tooltip = "Enable the rep bars at the bottom of the screen",
        },
        {
          name = "ActionBarsEnabled",
          typ = "checkbox",
          default = false,
          table = function(db) return db.settings.actionBars end,
          key = "enabled",
          label = "Use action bars",
          tooltip = "Enable the replacement action bars",
        },
        {
          name = "HUDEnabled",
          typ = "checkbox",
          default = false,
          table = function(db) return db.settings.hud end,
          key = "enabled",
          label = "Use HUD",
          tooltip = "Enable the HUD",
        },
        {
          name = "CommandEnabled",
          typ = "checkbox",
          default = false,
          table = function(db) return db.settings.command end,
          key = "enabled",
          label = "Use Fancy Command",
          tooltip = "Enable fancy command input",
        },
        {
          name = "ChatEnabled",
          typ = "checkbox",
          default = false,
          table = function(db) return db.settings.chat end,
          key = "enabled",
          label = "Use Fancy Chat",
          tooltip = "Enable fancy chat features",
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
          name = "HidePlayerFrame",
          typ = "checkbox",
          default = false,
          table = function(db) return db.settings.blizz end,
          key = "hidePlayerFrame",
          label = "Hide player frame",
          tooltip = "Hide player frame",
        },
        {
          name = "HideTargetFrame",
          typ = "checkbox",
          default = false,
          table = function(db) return db.settings.blizz end,
          key = "hideTargetFrame",
          label = "Hide target frame",
          tooltip = "Hide target frame",
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
  if 2 == db.version then
    db.settings.hud = { enabled = false }
    db.version = 3
  end
  if 3 == db.version then
    db.settings.chat = { enabled = false }
    db.settings.command = { enabled = false }
    db.version = 4
  end
end

local Hider = ns.wowui.CreateFrame("Frame")
Hider:Hide()

function ns:settingChanged(var, value, name) --, setting
  if "HideDefaultXPBar" == name then
    ns.wowui.StatusTrackingBarManager:SetShown(not value)
  end
  if "HideMicroMenu" == name then
    ns.wowui.MicroMenuContainer:SetShown(not value)
  end
  if "HideBags" == name then
    ns.wowui.BagsBar:SetShown(not value)
  end
  if "HidePlayerFrame" == name then
    ns.wowui.PlayerFrame:SetShown(not value)
    ns.wowui.PlayerFrame:SetParent(Hider)
  end
  if "HideTargetFrame" == name then
    ns.wowui.TargetFrame:SetShown(not value)
    ns.wowui.TargetFrame:SetParent(Hider)
  end

  if "XpBarEnabled" == name then
    if self.xpBar then
      self.xpBar:SetShown(value)
    elseif value then
      self.xpBar = self.ExpBar:new{}
      self.xpBar:PLAYER_ENTERING_WORLD(false, true)
    end
  end
  if "HUDEnabled" == name then
    if self.hud then
      self.hud:SetShown(value)
    elseif value then
      self.hud = ns.HUD:new{}
    end
  end
  if "ChatEnabled" == name then
  end
  if "CommandEnabled" == name then
    if self.command then
      -- todo: disable
    elseif value then
      self.command = ns.Command:new{}
    end
  end
end

function ns:onLoad()
  if self.db.settings.xpBar.hideDefault then
    ns.wowui.StatusTrackingBarManager:Hide()
  end
  if self.db.settings.blizz.hideMicroMenu then
    ns.wowui.MicroMenuContainer:Hide()
  end
  if self.db.settings.blizz.hideBags then
    ns.wowui.BagsBar:Hide()
  end
  if self.db.settings.blizz.hidePlayerFrame then
    ns.wowui.PlayerFrame:Hide()
    ns.wowui.PlayerFrame:SetParent(Hider)
  end
  if self.db.settings.blizz.hideTargetFrame then
    ns.wowui.TargetFrame:Hide()
    ns.wowui.TargetFrame:SetParent(Hider)
  end

  local maxLvl = self.wow.Player:isMaxLevel()
  if self.db.settings.xpBar.enabled and not maxLvl and not self.xpBar then
    self.xpBar = ns.ExpBar:new{}
  end
  if self.db.settings.repBars.enabled and maxLvl and not self.repBars then
    self.repBars = ns.RepBarContainer:new{}
  end
end

function ns:onLogin()
  if self.db.settings.actionBars.enabled and not self.actionBars then
    self.actionBars = ns.ActionBars:new{}
  end
  if self.db.settings.hud.enabled and not self.hud then
    self.hud = ns.HUD:new{}
  end
  if self.db.settings.command.enabled and not self.command then
    self.command = ns.Command:new{}
  end
end

ns.ui = LibNUI

-- Disable the reagent bag tutorial
-- /run HelpTip:HideAllSystem("TutorialReagentBag")
-- C_CVar.SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG, true)
-- C_CVar.SetCVar("professionToolSlotsExampleShown", 1)
-- C_CVar.SetCVar("professionAccessorySlotsExampleShown", 1)
