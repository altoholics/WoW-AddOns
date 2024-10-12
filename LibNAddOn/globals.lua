local _, ns = ...
-- luacheck: globals PowerBarColor

local PowerBarColor = PowerBarColor

-- https://www.rapidtables.com/convert/color/hex-to-rgb.html
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
  DullRed = {0.749, 0.149, 0.149},
  LightBlue = {0.529, 0.671, 1},
  LightYellow = {1, 1, 0.6},
  Gold = {0.949, 0.902, 0.6},
  Green = {0.098, 1, 0.098},
  White = {1, 1, 1},

  -- Chat
  Achievement = {1, 0.988, 0.004},
  BattleNet = {0, 0.6784, 0.9373},
  BNWhisper = {0, 0.9804, 0.9647},
  Emote = {1, 0.494, 0.251},
  General = {0.996, 0.7569, 0.7529},
  Guild = {0.2352941176, 0.8823529411764706, 0.247},
  Officer = {0.25, 0.7372549019607844, 0.25},
  Party = {0.67, 0.67, 0.996},
  PartyLead = {0.47, 0.78, 1},
  Raid = {1, 0.49, 0.004},
  RaidLeader = {1, 0.2784, 0.0353},
  RaidWarn = {1, 0.2784, 0},
  System = {1, 1, 0},
  Whisper = {1, 0.494, 1},
  Yell = {1, 0.247, 0.251},
}

function ns.linkGlobals(addOn, features)
  addOn[features.lua or "lua"] = ns.lua
  addOn[features.wow or "wow"] = ns.wow
  addOn[features.wowui or "wowui"] = ns.wowui
  addOn.Colors = Colors
end
