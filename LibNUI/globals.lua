local _, ns = ...
-- luacheck: globals FrameColor_CreateSkinModule

-- define the namespace layout

ns.util = {}

ns.ui = {}

-- put ui api in global scope for use by other addons
LibNUI = ns.ui

ns.g = {
  -- FrameColor API
  FrameColor_CreateSkinModule = FrameColor_CreateSkinModule,

  -- https://wowpedia.fandom.com/wiki/Wowpedia:Interface_customization
  Mixin = Mixin,

  -- WoW FrameXML API
  IsAddOnLoaded = C_AddOns.IsAddOnLoaded,
  CreateFrame = CreateFrame,
  ShowUIPanel = ShowUIPanel,
  HideUIPanel = HideUIPanel,
  UISpecialFrames = UISpecialFrames,
  UIParent = UIParent,
}
