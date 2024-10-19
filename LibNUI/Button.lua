local _, ns = ...
-- luacheck: globals NumberFontNormalSmallGray CreateFont GetCursorInfo
local ui = ns.ui
local Class, unpack = ns.lua.Class, ns.lua.unpack
local Frame = ui.Frame
local GameTooltip, SetOverrideBindingClick = ns.wowui.GameTooltip, ns.wowui.SetOverrideBindingClick
local GetCursorInfo = GetCursorInfo

local file, _, flags = NumberFontNormalSmallGray:GetFont()
local keybindFont = CreateFont("LibNUIButtonKeybind")
keybindFont:SetFont(file, 7, flags)

local patterns = {
  ["ALT%-"] = "a-", -- alt
  ["CTRL%-"] = "c-", -- ctrl
  ["SHIFT%-"] = "s-", -- shift
}

local function formatKeybind(bind)
  for p,s in pairs(patterns) do
    bind = bind:gsub(p, s)
  end
  return bind
end

-- https://wowpedia.fandom.com/wiki/UIOBJECT_Button
local Button = Class(Frame, function(self)
  if self.normal then
    if self.normal.texture then
      self.frame:SetNormalTexture(self.normal.texture)
    end
    if self.normal.coords then
      self.frame:GetNormalTexture():SetTexCoord(unpack(self.normal.coords))
    end
  end

  if self.onClick then
    self.frame:SetScript("OnClick", function() self:onClick() end)
  end
  self.frame:RegisterForClicks("AnyDown", "AnyUp")

  -- https://wowpedia.fandom.com/wiki/Creating_key_bindings
  if self.bindLeftClick then
    SetOverrideBindingClick(self.frame, false, self.bindLeftClick, self.frame:GetName(), "LeftButton")
    if self.kbLabel ~= false then
      self:withLabel("keybind", {
        text = formatKeybind(self.bindLeftClick),
        color = {0.8, 0.8, 0.8, 1},
        fontObj = keybindFont,
        position = {
          topRight = {0, -2},
          height = 7,
        },
      })
    end
  end

  -- hover texture
  if self.glow ~= false then
    self:withTextureOverlay("border", {
      path = "interface/buttons/UI-ActionButton-Border",
      blendMode = "ADD",
      position = {
        all = true,
        hide = true,
      },
      coords = {0.21, 0.77, 0.24, 0.79},
    })
  end
end, {
  type = "Button",
  scripts = {
    "OnEnter",
    "OnLeave",
    "OnMouseDown",
    "OnMouseUp",
  },
})
ui.Button = Button

function Button:OnMouseDown()
  if self.border then self.border:SetVertexColor(0, 1, 0) end
  if self.allowAnyTarget then
    -- local info = SafePack(GetCursorInfo())
    print(GetCursorInfo())
  end
end

function Button:OnMouseUp()
  if self.border then self.border:SetVertexColor(1, 1, 1) end
end

function Button:OnEnter()
  if self.border then self.border.texture:Show() end
  if self.tooltip then
    local gt = self.tooltip.frame
    if not gt then
      gt = GameTooltip
      if self.tooltip.owner then
        gt:SetOwner(unpack(self.tooltip.owner))
      else
        gt:SetOwner(self.frame, "ANCHOR_TOPRIGHT", -2, 0)
      end
      if self.tooltip.point then
        gt:SetPoint(unpack(self.tooltip.point))
      end
    end
    local td = self.tooltip
    if td.itemId then
      gt:SetOwnedItemByID(td.itemId)
    elseif td.toyId then
      gt:SetToyByItemID(td.toyId)
    elseif td.spellId then
      gt:SetSpellByID(td.spellId)
    elseif td.mountSpellId then
      gt:SetMountBySpellID(td.mountSpellId)
    end
    gt:Show()
  end
end

function Button:OnLeave()
  if self.border then self.border.texture:Hide() end
  if self.tooltip then (self.tooltip.frame or GameTooltip):Hide() end
end
