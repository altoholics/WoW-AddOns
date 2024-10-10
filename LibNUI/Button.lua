local _, ns = ...
-- luacheck: globals SetOverrideBindingClick NumberFontNormalSmallGray CreateFont
local ui = ns.ui
local Class, unpack = ns.lua.Class, ns.lua.unpack
local Frame = ui.Frame

local file, _, flags = NumberFontNormalSmallGray:GetFont()
local keybindFont = CreateFont("ButtonKeybind")
keybindFont:SetFont(file, 7, flags)

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
    self:withLabel("keybind", {
      text = string.gsub(self.bindLeftClick, "CTRL", "c"),
      color = {0.8, 0.8, 0.8, 1},
      fontObj = keybindFont,
      position = {
        topRight = {0, -2},
      },
    })
  end

  -- hover texture
  self:withTextureOverlay("border", {
    texturePath = "interface/buttons/UI-ActionButton-Border",
    blendMode = "ADD",
    positionAll = true,
    coords = {0.21, 0.77, 0.24, 0.79},
  })
  local border = self.border.texture
  border:Hide()
  self.frame:SetScript("OnEnter", function()
    border:Show()
  end)
  self.frame:SetScript("OnLeave", function()
    border:Hide()
  end)
  self.frame:SetScript("OnMouseDown", function()
    border:SetVertexColor(0, 1, 0)
  end)
  self.frame:SetScript("OnMouseUp", function()
    border:SetVertexColor(1, 1, 1)
  end)
end, {
  type = "Button",
})
ui.Button = Button
