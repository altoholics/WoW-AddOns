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
  ShowUIPanel = ShowUIPanel,
  HideUIPanel = HideUIPanel,

  -- libs
  ui = LibNUI,
}

function ns.GetPlayerLevelXP()
  local level = UnitLevel("player")
  local currentXP = UnitXP("player")
  local maxXP = UnitXPMax("player")
  return currentXP, maxXP, level, ns.g.maxLevel
end
