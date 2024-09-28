local _, ns = ...
-- luacheck: globals CreateColor CreateFrame ShowUIPanel HideUIPanel UISpecialFrames UIParent Settings
-- luacheck: globals StatusTrackingBarManager BagsBar MicroMenuContainer MainMenuBar MultiBarBottomLeft
-- luacheck: globals MultiBarBottomRight MultiBarRight MultiBarLeft MultiBar5 MultiBar6 MultiBar7 Tutorials

ns.wowui = {
  CreateColor = CreateColor,

  -- WoW FrameXML API
  CreateFrame = CreateFrame,
  ShowUIPanel = ShowUIPanel,
  HideUIPanel = HideUIPanel,
  UISpecialFrames = UISpecialFrames,
  UIParent = UIParent,

  Settings = Settings,
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
}

function ns.wowui.rgba(r, g, b, a)
  return ns.wowui.CreateColor(r/255, g/255, b/255, a)
end
