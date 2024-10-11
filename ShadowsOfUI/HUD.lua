local _, ns = ...
local Class = ns.lua.Class
local ui = ns.ui
local Frame, StatusBar, Texture = ui.Frame, ui.StatusBar, ui.Texture
local Player = ns.wow.Player
local rgba = ns.wowui.rgba

local HealthBar = Class(StatusBar, function(self)
  local className = Player:GetClassName()
  self:Color(ns.Colors[className])
  self:withTextureOverlay("leftEdge", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"HORIZONTAL", rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0)},
    position = {
      topLeft = {},
      bottomLeft = {self.frame, ui.edge.BottomLeft},
      width = 5,
    },
  })
  self:withLabel("level", {
    text = Player:GetLevel(),
    font = "GameFontNormalSmall",
    -- color = ns.Colors.Gold,
    position = {
      topRight = {self.frame, ui.edge.TopLeft, -2, -2}
    },
  })
  self:withLabel("hp", {
    text = Player:GetHealth(),
    font = "GameFontHighlight",
    position = {
      topRight = {self.level.label, ui.edge.BottomRight, 0, -2},
    },
  })
  self:withLabel("hpPcnt", {
    text = Player:GetHealthPercent(),
    font = "GameFontHighlight",
    position = {
      topRight = {self.hp.label, ui.edge.BottomRight, 0, -2},
    },
  })
end, {
  backdrop = {color={0, 0, 0, 0.2}},
  orientation = "VERTICAL",
  position = {
    center = {-80, 0},
    width = 10,
    height = 150,
  },
  unitEvents = {
    UNIT_HEALTH = {"player"},
  },
})

function HealthBar:UNIT_HEALTH()
  local hp, max, pcnt = Player.GetHealthValues()
  self.frame:SetMinMaxValues(0, max)
  self.frame:SetValue(hp)
  self.hp.label:Text(hp)
  self.hpPcnt.label:Text(pcnt)
end

local PowerBar = Class(StatusBar, function(self)
  local _, powerKey, altR, altG, altB = Player:GetPowerType()
  local color = ns.Colors.PowerBarColor[powerKey]
  if color then
    self:Color({color.r, color.g, color.b})
  elseif altR then
    self:Color({altR, altG, altB})
  end

  self:withTextureOverlay("leftEdge", {
    color = {0, 0, 0, 0.5},
    position = {
      topLeft = {},
      bottomLeft = {self.frame, ui.edge.BottomLeft},
      width = 1,
    },
  })
  self:withTextureOverlay("rightEdge", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"HORIZONTAL", rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.5)},
    position = {
      topRight = {},
      bottomRight = {self.frame, ui.edge.BottomRight},
      width = 5,
    },
  })

  self:UNIT_POWER_FREQUENT()
end, {
  backdrop = {color={0, 0, 0, 0.2}},
  orientation = "VERTICAL",
  color = {0, 0, 1},
  position = {
    center = {-72, 0},
    width = 6,
    height = 150,
  },
  unitEvents = {
    UNIT_POWER_FREQUENT = {"player"},
  },
})

-- https://wowpedia.fandom.com/wiki/API_UnitPowerType
function PowerBar:UNIT_POWER_FREQUENT(_, powerType, ...)
  if powerType == "MANA" or powerType == "RAGE" or powerType == "FOCUS" or powerType == "ENERGY" or powerType == "CHI"
  or powerType == "INSANITY" or powerType == "FURY" or powerType == "PAIN" then
    local power, x = Player.GetPowerValues()
    self.frame:SetMinMaxValues(0, x)
    self.frame:SetValue(power)
  end
end

local PetBar = Class(StatusBar, function(self)
  local className = Player:GetClassName()
  self:Color(ns.Colors[className])
end, {
  orientation = "VERTICAL",
  position = {
    center = {-89, -75/2},
    width = 6,
    height = 75,
  },
  unitEvents = {
    UNIT_HEALTH = {"pet"},
    UNIT_PET = {"player"},
  },
})

function PetBar:UNIT_HEALTH()
  local hp, max = Player.GetPetHealthValues()
  self.frame:SetMinMaxValues(0, max)
  self.frame:SetValue(hp)
end

function PetBar:UNIT_PET()
  self.frame:SetShown(ns.wow.UnitExists("pet"))
end

local ResourceBar = Class(Frame, function(self)
  local classId = Player:GetClassId()
  self.resourceIdx = nil
  self.fill = {}
  -- https://wowpedia.fandom.com/wiki/Enum.PowerType
  if classId == 9 then
    self.resourceIdx = 7
    for i=1,5 do
      Texture:new{
        parent = self,
        textureLayer = "BACKGROUND",
        atlas = "UF-SoulShard-Holder",
        blend = "BLEND",
        position = {
          left = {(i-1)*25, 0},
          width = 23,
          height = 30,
        },
      }
      self.fill[i] = Texture:new{
        parent = self,
        textureLayer = "ARTWORK",
        atlas = "UF-SoulShard-Icon",
        blend = "BLEND",
        position = {
          left = {(i-1)*25+4, 2},
          width = 15,
          height = 20,
        },
      }
    end
  end
  local power = Player:GetPower(self.resourceIdx)
  for i=1,#self.fill do
    self.fill[i].texture:SetShown(i <= power)
  end
end, {
  position = {
    center = {0, -90},
    height = 26,
    width = 125,
  },
})

local HUD = Class(Frame, function(self)
  self.health = HealthBar:new{parent = self}
  self.power = PowerBar:new{parent = self}
  self.resource = ResourceBar:new{parent = self}

  local classId = Player:GetClassId()
  if classId == 9 or classId == 3 then
    self.pet = PetBar:new{parent = self}
  end

  self:PLAYER_TARGET_CHANGED()
end, {
  parent = ns.wowui.UIParent,
  position = {
    center = true,
    width = 300,
    height = 300,
  },
  events = {"PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED"},
})
ns.HUD = HUD

function HUD:PLAYER_REGEN_DISABLED()
  self.frame:SetAlpha(0.9)
end

function HUD:PLAYER_REGEN_ENABLED()
  self.frame:SetAlpha(0)
end

function HUD:PLAYER_TARGET_CHANGED()
  self.frame:SetAlpha((Player:InCombat() or Player:HasTarget()) and 0.9 or 0)
end
