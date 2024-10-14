local _, ns = ...
local ui, Player, Items = ns.ui, ns.wow.Player, ns.wow.Items
local Class, tinsert, Fill = ns.lua.Class, ns.lua.tinsert, ns.lua.Fill
local Frame, SecureButton = ui.Frame, ui.SecureButton
local GetSpellName, GetSpellTexture = ns.wow.GetSpellName, ns.wow.GetSpellTexture
local HasToy, IsSpellKnown = Player.HasToy, Player.IsSpellKnown
local IsMountCollected, GetMountIcon = Player.IsMountCollected, Player.GetMountIcon
local Bottom = ui.edge.Bottom

local VerticalBar = Class(Frame, function(self)
  self.buttons = {}

  if self.mouseOverAlpha then self:RegisterScript("OnEnter", "OnLeave") end
end, {
  parent = ns.wowui.UIParent,
  spacing = 2,
  iconSize = 30,
  smallSize = 20,
})
ns.VerticalBar = VerticalBar

function VerticalBar:OnEnter() self.frame:SetAlpha(self.mouseOverAlpha) end
function VerticalBar:OnLeave() if not self.frame:IsMouseOver() then self.frame:SetAlpha(self.alpha) end end

function VerticalBar:UpdateHeight()
  self:height(#self.buttons * self.iconSize + (#self.buttons-1) * self.spacing)
end

function VerticalBar:addSecureButton(ops)
  local btn = SecureButton:new(Fill(ops, {
    parent = self,
    position = {
      [self.firstButtonPoint] = #self.buttons == 0 and {} or nil,
      top = #self.buttons > 0 and {self.buttons[#self.buttons].frame, Bottom, 0, -self.spacing} or nil,
      width = self.iconSize,
      height = self.iconSize,
    },
    normal = {
      coords = {0.07, 0.93, 0.07, 0.93},
    },
    tooltip = {
      owner = {self.frame, "ANCHOR_NONE"},
      point = self.tooltipPoint,
    },
  }))
  if not ops.offset then tinsert(self.buttons, btn) end
  return btn
end

function VerticalBar:addToyButton(id)
  return HasToy(id) and self:addSecureButton{
    normal = {
      texture = Items.GetIcon(id),
    },
    actions = {
      {
        type = "toy",
        toy = id,
      },
    },
    tooltip = { toyId = id },
  }
end

function VerticalBar:addOffsetToyButton(id, target, x, y)
  return HasToy(id) and self:addSecureButton{
    offset = true,
    level = target.frame:GetFrameLevel() + 1,
    position = {
      top = false,
      right = {target.frame, ui.edge.Left, x or 2 * self.spacing, y or 0},
      width = self.smallSize,
      height = self.smallSize,
    },
    normal = {
      texture = Items.GetIcon(id),
    },
    actions = {
      {
        type = "toy",
        toy = id,
      },
    },
    tooltip = { toyId = id },
  }
end

function VerticalBar:addSpellButton(id, icon)
  return IsSpellKnown(id) and self:addSecureButton{
    normal = {
      texture = icon or GetSpellTexture(id),
    },
    actions = {
      {
        type = "spell",
        spell = id,--GetSpellName(id),
      },
    },
    tooltip = { spellId = id },
  }
end

function VerticalBar:addOffsetSpellButton(id, icon, target, x, y)
  return IsSpellKnown(id) and self:addSecureButton{
    offset = true,
    level = target.frame:GetFrameLevel() + 1,
    position = {
      top = false,
      right = {target.frame, ui.edge.Left, x or 2 * self.spacing, y or 0},
      width = self.smallSize,
      height = self.smallSize,
    },
    normal = {
      texture = icon or GetSpellTexture(id),
    },
    actions = {
      {
        type = "spell",
        spell = GetSpellName(id),
      },
    },
    tooltip = { spellId = id },
  }
end

function VerticalBar:addMountButton(id, spell, name, bind)
  return IsMountCollected(id) and self:addSecureButton{
    name = name,
    normal = {
      texture = GetMountIcon(id),
    },
    actions = {
      {
        type = "spell",
        spell = GetSpellName(spell),
      },
    },
    bindLeftClick = bind,
    tooltip = { mountSpellId = spell },
  }
end
