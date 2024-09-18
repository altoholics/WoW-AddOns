-- ignore unused arguments
ignore = {"212"}
std = "max"
stds.myapi = {
  globals = {
    "LibNUI",
  }
}
stds.wowapi = {
  read_globals = {
    "BagsBar",
    "C_AddOns",
    "C_ClassColor",
    "C_DateAndTime",
    "C_CVar",
    "C_MajorFactions",
    "CopyTable",
    "CreateColor",
    "CreateFrame",
    "GetAverageItemLevel",
    "GetClassInfo",
    "GetFactionInfoByID",
    "GetMaxLevelForPlayerExpansion",
    "GetNumClasses",
    "GetProfessionInfo",
    "GetProfessions",
    "GetRealmName",
    "GetRestState",
    "GetServerTime",
    "GetXPExhaustion",
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
    "UISpecialFrames",
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