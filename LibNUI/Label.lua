local _, ns = ...
local ui = ns.ui

local unpack = ns.lua.unpack
local Class, Drop = ns.lua.Class, ns.lua.Drop
local ScriptRegion = ui.ScriptRegion

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_FontStyles_Shared/SharedFontStyles.xml
-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_FontStyles_Frame/Mainline/FontStyles.xml
ui.fonts = ns.lua.ToMap({
  "GameFontHighlight", "GameFontHighlightSmall",
  "SystemFont_Med2",
})

local Label = Class(ScriptRegion, function(self)
  if self.fontObj then self._widget:SetFontObject(self.fontObj) end
  if self.text then self._widget:SetText(self.text) end
  if self.alpha then self._widget:SetAlpha(self.alpha) end
  if self.color then
    self._widget:SetTextColor(unpack(self.color))
  end
  if self.justifyH then
    self._widget:SetJustifyH(self.justifyH)
  end
  if self.justiftV then
    self._widget:SetJustifyV(self.justiftV)
  end
end, {
  CreateWidth = function(self)
    local parent, name, layer, font = Drop(self, "parent", "name", "layer", "font")
    return (parent._widget or parent):CreateFontString(name, layer, font)
  end,
  layer = ui.layer.Artwork,
  font = ui.fonts.GameFontHighlight
})
ui.Label = Label

function Label:Text(text)
  if not text then return self._widget:GetText() end
  self._widget:SetText(text)
  return self
end

function Label:Color(r, g, b, a)
  self._widget:SetTextColor(r, g, b, a)
end
