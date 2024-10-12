local _, ns = ...
local Class = ns.lua.Class
local ui = ns.ui
local Frame = ui.Frame
local Player = ns.wow.Player
local PlayerHealthBar, PlayerPowerBar, ResourceBar = ns.PlayerHealthBar, ns.PlayerPowerBar, ns.ResourceBar
local PetBar = ns.PetBar

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
  ns.Colors.DullRed,
  nil,
  ns.Colors.Blue,
  ns.Colors.Corruption,
  nil,
  ns.Colors.LightYellow
}

local PlayerHUD = Class(Frame, function(self)
  local classId = Player:GetClassId()

  self.health = PlayerHealthBar:new{parent = self}
  self.power = PlayerPowerBar:new{parent = self, classId = classId}

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
  name = "$parentPlayer",
  position = {
    width = 1,
    height = 1,
  },
})
ns.PlayerHUD = PlayerHUD
