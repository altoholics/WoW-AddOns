local _, ns = ...
local ui = ns.ui

local unpack = ns.lua.unpack
local Class = ns.lua.Class
local Region = ui.Region

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_FontStyles_Shared/SharedFontStyles.xml
-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_FontStyles_Frame/Mainline/FontStyles.xml
ui.fonts = ns.lua.ToMap({
  "GameFontHighlight", "GameFontHighlightSmall",
  "SystemFont_Med2",
})

local Label = Class(Region, function(self)
  if self.fontObj then self._widget:SetFontObject(self.fontObj) end
  if self.fontInfo then self._widget:SetFont(unpack(self.fontInfo)) end
  if self.text then self:Text(self.text) end
  if self.color then self:Color(unpack(self.color)) end

  if self.justifyH then self._widget:SetJustifyH(self.justifyH) end
  if self.justifyV then self._widget:SetJustifyV(self.justifyV) end
end, {
  CreateWidget = function(self)
    return (self.parent._widget or self.parent):CreateFontString(self.name, self.layer, self.font)
  end,
  layer = ui.layer.Artwork,
  font = ui.fonts.GameFontHighlight,
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
