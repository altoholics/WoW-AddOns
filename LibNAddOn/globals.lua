local _, ns = ...
-- luacheck: globals PowerBarColor

local PowerBarColor = PowerBarColor

local Colors = {
  -- https://wowpedia.fandom.com/wiki/Class_colors
  DeathKnight = {0.77, 0.12, 0.23},
  DemonHunter = {0.64, 0.19, 0.79},
  Druid = {1, 0.49, 0.04},
  Evoker = {0.2, 0.58, 0.5},
  Hunter = {0.67, 0.83, 0.45},
  Mage = {0.41, 0.8, 0.94},
  Monk = {0.33, 0.54, 0.52},
  Paladin = {0.96, 0.55, 0.73},
  Priest = {1, 1, 1},
  Rogue = {1, 0.96, 0.41},
  Shaman = {0, 0.44, 0.87},
  Warlock = {0.58, 0.51, 0.79},
  Warrior = {0.78, 0.61, 0.43},

  PowerBarColor = PowerBarColor,

  -- https://wowpedia.fandom.com/wiki/ColorMixin#Global_Colors
  Blue = {0, 0.749, 0.953},
  Corruption = {0.584, 0.427, 0.82},
  LightBlue = {0.529, 0.671, 1},
  LightYellow = {1, 1, 0.6},
  Gold = {0.949, 0.902, 0.6},
}

function ns.linkGlobals(addOn, features)
  addOn[features.lua or "lua"] = ns.lua
  addOn[features.wow or "wow"] = ns.wow
  addOn[features.wowui or "wowui"] = ns.wowui
  addOn.Colors = Colors
end
