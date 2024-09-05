local _, ns = ...

-- This file serves as the global api layer for the addon
-- it is the only file with references to global vars.
-- This helps prevent accidental leakage, and performance issues
-- It also helps isolate the addon code from changes to global functions

-- the globals used by the mod
ns.g = {
  -- basic globals

  -- WoW functions
  CreateColor = CreateColor,
  UnitLevel = UnitLevel,
  UnitXP = UnitXP,
  UnitXPMax = UnitXPMax,
  GetXPExhaustion = GetXPExhaustion,
  GetRestState = GetRestState,
  maxLevel = GetMaxLevelForPlayerExpansion(),
  ShowUIPanel = ShowUIPanel,
  HideUIPanel = HideUIPanel,
  UnitExists = UnitExists,
  UnitAffectingCombat = UnitAffectingCombat,
  GetFactionInfoByID = GetFactionInfoByID,
  GetMajorFactionRenownInfo = C_MajorFactions.GetMajorFactionRenownInfo,
  IsAddonLoaded = C_AddOns.IsAddOnLoaded,

  -- WoW objects
  UIParent = UIParent,
  StatusTrackingBarManager = StatusTrackingBarManager,
  BagsBar = BagsBar,
  MicroMenuContainer = MicroMenuContainer,
  MainMenuBar = MainMenuBar,
  MultiBarBottomLeft = MultiBarBottomLeft,
  MultiBarBottomRight = MultiBarBottomRight,
  MultiBarRight = MultiBarRight,
  MultiBarLeft = MultiBarLeft,
  MultiBar5 = MultiBar5,
  MultiBar6 = MultiBar6,
  MultiBar7 = MultiBar7,
  Tutorials = Tutorials,

  -- libs
  ui = LibNUI,
}

function ns.CreateColor(r, g, b, a)
  return ns.g.CreateColor(r/255, g/255, b/255, a)
end

function ns.GetPlayerLevelXP()
  local level = UnitLevel("player")
  local currentXP = UnitXP("player")
  local maxXP = UnitXPMax("player")
  return currentXP, maxXP, level, ns.g.maxLevel
end

function ns.min(a, b)
  return a < b and a or b
end

-- Disable the reagent bag tutorial
C_CVar.SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG, true)
C_CVar.SetCVar("professionToolSlotsExampleShown", 1)
C_CVar.SetCVar("professionAccessorySlotsExampleShown", 1)
