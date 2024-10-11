local _, ns = ...
local Class = ns.lua.Class
local AbbreviateNumbers = ns.lua.AbbreviateNumbers
local ui = ns.ui
local Frame, StatusBar, Texture = ui.Frame, ui.StatusBar, ui.Texture
local Player = ns.wow.Player
local rgba = ns.wowui.rgba

local HealthBar = Class(StatusBar, function(self)
  local className = gsub(Player:GetClassName(), " ", "")
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
    text = AbbreviateNumbers(Player:GetHealth()),
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
  local hp, max, pcnt = Player:GetHealthValues()
  self.frame:SetMinMaxValues(0, max)
  self.frame:SetValue(hp)
  self.hp:Text(AbbreviateNumbers(hp))
  self.hpPcnt:Text(pcnt)
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

  if self.classId == 11 then -- druid
    self:registerEvent("UPDATE_SHAPESHIFT_FORM")
    self:UPDATE_SHAPESHIFT_FORM()
  end

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
  or powerType == "INSANITY" or powerType == "FURY" or powerType == "PAIN" or powerType == "RUNIC_POWER" then
    local power, x = Player:GetPowerValues()
    self.frame:SetMinMaxValues(0, x)
    self.frame:SetValue(power)
  end
end

function PowerBar:UPDATE_SHAPESHIFT_FORM()
  local _, powerKey, altR, altG, altB = Player:GetPowerType()
  local color = ns.Colors.PowerBarColor[powerKey]
  if color then
    self:Color({color.r, color.g, color.b})
  elseif altR then
    self:Color({altR, altG, altB})
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

local PowerByClass = {
  nil,
  9, -- paladin holy power
  nil,
  4, -- rogue combo points
  nil,
  5, -- death knight runes
  nil,
  16, -- mage arcane charges
  7, -- warlock soul shard
  nil,
  4, -- druid combo points
}
local ResourceColorByClass = {
  nil,
  ns.Colors.Gold,
  nil,
  ns.Colors.LightYellow,
  nil,
  ns.Colors.LightBlue,
  nil,
  ns.Colors.Blue,
  ns.Colors.Corruption,
  nil,
  ns.Colors.LightYellow
}

local ResourceBar = Class(StatusBar, function(self)
  self.countMax = Player:GetPowerMax(self.resourceIdx)
  if self.countMax == 6 then self:width(198)
  elseif self.countMax == 7 then self:width(196)
  end

  self.border = Frame:new{
    parent = self,
    name = "$parentBorder",
    template = "BackdropTemplate",
    position = {
      topLeft = {self.frame, ui.edge.TopLeft, -3, 3},
      bottomRight = {self.frame, ui.edge.BottomRight, 3, -3},
    },
  }
  -- from BackdropTemplate
  self.border.frame:SetBackdrop({
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
  })
  self.border.frame:SetBackdropBorderColor(0, 0, 0, .5)

  -- notches
  local o = self:width() / self.countMax
  for i=1,self.countMax-1 do
    Texture:new{
      parent = self,
      layer = "OVERLAY",
      position = {
        left = {i*o, 0},
        height = 14,
        width = 2,
      },
      color = {0, 0, 0, 0.8},
    }
  end

  if self.classId == 11 then -- druid
    self:registerEvent("UPDATE_SHAPESHIFT_FORM")
    self:UPDATE_SHAPESHIFT_FORM()
  elseif self.classId == 6 then -- DK
    self:registerEvent("RUNE_POWER_UPDATE")
    self:RUNE_POWER_UPDATE()
  end

  local p = Player:GetPower(self.resourceIdx)
  self.frame:SetValue(p / self.countMax)
end, {
  min = 0,
  max = 1,
  backdrop = {color={0, 0, 0, 0.2}},
  position = {
    center = {0, -90},
    width = 200,
    height = 14,
  },
  unitEvents = {
    UNIT_POWER_FREQUENT = {"player"},
  },
})

function ResourceBar:UNIT_POWER_FREQUENT(_, powerType)
  if powerType == "SOUL_SHARDS" or powerType == "HOLY_POWER"
  or powerType == "ARCANE_CHARGES" or powerType == "COMBO_POINTS" then
    self.frame:SetValue(Player:GetPower(self.resourceIdx) / self.countMax)
  end
end

function ResourceBar:RUNE_POWER_UPDATE()
  self.frame:SetValue(Player:GetPower(self.resourceIdx) / self.countMax)
end

function ResourceBar:UPDATE_SHAPESHIFT_FORM()
  -- we only register this for druid, so only show in cat form for combo points
  self:SetShown(Player:GetShapeshiftFormID() == 1) -- cat form
end

local PlayerHUD = Class(Frame, function(self)
  local classId = Player:GetClassId()

  self.health = HealthBar:new{parent = self}
  self.power = PowerBar:new{parent = self, classId = classId}

  local resourceIdx = PowerByClass[classId]
  if resourceIdx then
    self.resource = ResourceBar:new{
      parent = self,
      classId = classId,
      resourceIdx = resourceIdx,
      color = ResourceColorByClass[classId],
    }
  end

  if classId == 9 or classId == 3 then -- warlock, hunter
    self.pet = PetBar:new{parent = self}
  end
end, {
  position = {
    width = 300,
    height = 300,
  },
})
ns.PlayerHUD = PlayerHUD
