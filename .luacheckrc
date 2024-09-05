std = "min"
stds.myapi = {
  globals = {
    "LibNUI",
  }
}
stds.wowapi = {
  read_globals = {
    "pairs",
    "unpack",
    "BagsBar",
    "C_AddOns",
    "C_ClassColor",
    "C_CVar",
    "C_MajorFactions",
    "CopyTable",
    "CreateColor",
    "CreateFrame",
    "GetClassInfo",
    "GetFactionInfoByID",
    "GetMaxLevelForPlayerExpansion",
    "GetNumClasses",
    "GetXPExhaustion",
    "GetRestState",
    "HideUIPanel",
    "Mixin",
    "MainMenuBar",
    "MicroMenuContainer",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "InterfaceOptionsFrame_OpenToCategory",
    "ShowUIPanel",
    "SlashCmdList",
    "StatusTrackingBarManager",
    "Tutorials",
    "UIParent",
    "UnitAffectingCombat",
    "UnitClass",
    "UnitClassBase",
    "UnitExists",
    "UnitLevel",
    "UnitName",
    "UnitRace",
    "UnitXP",
    "UnitXPMax",
    "LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG",
  }
}
files["**/globals.lua"].std = "+myapi+wowapi"