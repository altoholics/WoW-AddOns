local _, ns = ...

local Settings = ns.wowui.Settings

function ns:registerSettings()
  print("registering settings...")
  local db = self.db
  local category = Settings.RegisterVerticalLayoutCategory("Shadows of UI")

  local function settingChanged(setting, value)
    print("Setting changed:", setting:GetVariable(), value)
  end

  do
    local setting = Settings.RegisterAddOnSetting(category, "XpBarEnabled", "enabled", db.settings.xpBar, type(true), "XP Bar enabled", true)
    setting:SetValueChangedCallback(settingChanged)
    Settings.CreateCheckbox(category, setting, "Enable the xp bar at the bottom of the screen")
  end

  Settings.RegisterAddOnCategory(category)
end
