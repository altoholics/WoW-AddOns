local _, ns = ...
local Class, gsub, unpack = ns.lua.Class, ns.lua.gsub, ns.lua.unpack
local ui = ns.ui
local StatusBar, Texture = ui.StatusBar, ui.Texture
local Player = ns.wow.Player

local offsets = {
  nil,
  nil,
  nil,
  { -- 4
    { x = -3, y = -35, r = math.pi / 2 },
    { x = -6, y = 2, r = math.pi / 2 },
    { x = -2.5, y = 38.5, r = math.pi / 2 },
  },
  { -- 5
    { x = -1, y = -45, r = math.pi / 2 },
    { x = -5, y = -15, r = math.pi / 2 },
    { x = -5, y = 15, r = math.pi / 2 },
    { x = -1, y = 45, r = math.pi / 2 },
  },
  { -- 6
    { x  = 0, y = -50, r = math.pi / 2 },
    { x  = -4, y = -25, r = math.pi / 2 },
    { x  = -6, y = 0, r = math.pi / 2 },
    { x  = -4, y = 25, r = math.pi / 2 },
    { x  = 0, y = 50, r = math.pi / 2 },
  },
  { -- 7
    { x = 0, y = -51, r = math.pi / 2 },
    { x = -3, y = -29, r = math.pi / 2 },
    { x = -6, y = -9, r = math.pi / 2 },
    { x = -5, y = 12, r = math.pi / 2 },
    { x = -3, y = 33, r = math.pi / 2 },
    { x = 0, y = 54, r = math.pi / 2 },
  },
  { -- 8
    { x = 0, y = -30, r = math.pi / 2 },
    { x = 0, y = -20, r = math.pi / 2 },
    { x = 0, y = -10, r = math.pi / 2 },
    { x = 0, y = 0, r = math.pi / 2 },
    { x = 0, y = 10, r = math.pi / 2 },
    { x = 0, y = 20, r = math.pi / 2 },
    { x = 0, y = 30, r = math.pi / 2 },
  },
}

local ResourceBar = Class(StatusBar, function(self)
  local className = gsub(Player:GetClassName(), " ", "")
  local t = self.frame:GetStatusBarTexture()
  t:SetVertexColor(unpack(ns.Colors[className]))

  local countMax = Player:GetPowerMax(self.resourceIdx)
  for i=1,countMax - 1 do
    Texture:new{
      parent = self,
      layer = "OVERLAY",
      path = "interface/addons/ShadowsOfUI/art/Separator.tga",
      coords = {0.359375, 0.640625, 0, 1},
      rotation = offsets[countMax][i].r,
      vertexColor = {0, 0, 0, 0.8},
      position = {
        center = {offsets[countMax][i].x, offsets[countMax][i].y},
        width = 4.5,
        height = 9,
      },
    }
  end

  if self.classId == 11 then -- druid
    self:registerEvent("UPDATE_SHAPESHIFT_FORM")
    self:UPDATE_SHAPESHIFT_FORM()
  elseif self.classId == 6 then -- DK
    self:registerEvent("RUNE_POWER_UPDATE")
    self:unregisterEvent("UNIT_POWER_FREQUENT")
  end

  self.frame:SetMinMaxValues(0, countMax)
  self:RUNE_POWER_UPDATE()
end, {
  name = "$parentResource",
  level = 5,
  backdrop = {
    color = false,
    path = "interface/addons/ShadowsOfUI/art/CleanCurvesBG",
    coords = {0.32, 0.05, 0.01, 0.99},
  },
  orientation = "VERTICAL",
  texture = {
    path = "interface/addons/ShadowsOfUI/art/CleanCurves",
    coords = {0.32, 0.05, 0.01, 0.99},
  },
  position = {
    center = {11, 0},
    width = 17,
    height = 150,
  },
  unitEvents = {
    UNIT_POWER_FREQUENT = {"player"},
  },
})
ns.ResourceBar = ResourceBar

function ResourceBar:UNIT_POWER_FREQUENT(_, powerType)
  if powerType == "SOUL_SHARDS" or powerType == "HOLY_POWER"
  or powerType == "ARCANE_CHARGES" or powerType == "COMBO_POINTS" then
    self:SetValue(Player:GetPower(self.resourceIdx))
  end
end

local GetRuneCooldown = GetRuneCooldown -- luacheck: globals GetRuneCooldown
function ResourceBar:RUNE_POWER_UPDATE()
  local amount = 0
  for i = 1, 6 do
    local _, _, runeReady = GetRuneCooldown(i)
    if runeReady then
      amount = amount + 1
    end
  end
  self:SetValue(amount)
end

function ResourceBar:UPDATE_SHAPESHIFT_FORM()
  -- we only register this for druid, so only show in cat form for combo points
  self:SetShown(Player:GetShapeshiftFormID() == 1) -- cat form
end
