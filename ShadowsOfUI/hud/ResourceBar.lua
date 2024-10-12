local _, ns = ...
local Class, tinsert = ns.lua.Class, ns.lua.tinsert
local ui = ns.ui
local Frame, Texture = ui.Frame, ui.Texture
local Player = ns.wow.Player

local OFFSETS = {
  nil, nil, nil, nil,
  { -- 5
    { x = 0, y = -80 },
    { x = 0, y = -40 },
    { x = 0, y = 0 },
    { x = 0, y = 40 },
    { x = 0, y = 80 },
  },
  { -- 6
    { x = 2, y = -76 },
    { x = -6, y = -45 },
    { x = -10, y = -14 },
    { x = -10, y = 14 },
    { x = -6, y = 45 },
    { x = 2, y = 76 },
  },
  { -- 7
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
  },
  nil,
  nil,
  { -- 10
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
    { x = 0, y = 0 },
  },
}

local ResourceBar = Class(Frame, function(self)
  self.countMax = Player:GetPowerMax(self.resourceIdx)

  self.bubbles = {}
  for i=1,self.countMax do
    local o = OFFSETS[self.countMax][i]
    Texture:new{
      parent = self,
      path = "interface/addons/ShadowsOfUI/art/ComboRoundBG",
      vertexColor = {0, 0, 0, 0.7},
      position = {
        center = {o.x, o.y},
        width = 18,
        height = 18,
      },
    }
    tinsert(self.bubbles, Texture:new{
      parent = self,
      path = "interface/addons/ShadowsOfUI/art/ComboRound",
      vertexColor = self.color,
      position = {
        center = {o.x, o.y},
        width = 18,
        height = 18,
      },
    })
  end

  if self.classId == 11 then -- druid
    self:registerEvent("UPDATE_SHAPESHIFT_FORM")
    self:UPDATE_SHAPESHIFT_FORM()
  elseif self.classId == 6 then -- DK
    self:registerEvent("RUNE_POWER_UPDATE")
  end

  local p = Player:GetPower(self.resourceIdx)
  self:SetValue(p)
end, {
  position = {
    center = {20, 0},
    width = 27,
    height = 188,
  },
  unitEvents = {
    UNIT_POWER_FREQUENT = {"player"},
  },
})
ns.ResourceBar = ResourceBar

function ResourceBar:SetValue(val)
  for i=1,#self.bubbles do
    self.bubbles[i]:SetShown(val >= i)
  end
end

function ResourceBar:UNIT_POWER_FREQUENT(_, powerType)
  if powerType == "SOUL_SHARDS" or powerType == "HOLY_POWER"
  or powerType == "ARCANE_CHARGES" or powerType == "COMBO_POINTS" then
    self:SetValue(Player:GetPower(self.resourceIdx))
  end
end

function ResourceBar:RUNE_POWER_UPDATE()
  self:SetValue(Player:GetPower(self.resourceIdx))
end

function ResourceBar:UPDATE_SHAPESHIFT_FORM()
  -- we only register this for druid, so only show in cat form for combo points
  self:SetShown(Player:GetShapeshiftFormID() == 1) -- cat form
end
