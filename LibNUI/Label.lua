local _, ns = ...
local ui = ns.ui

local unpack = ns.lua.unpack
local Class, Drop = ns.lua.Class, ns.lua.Drop
local Region = ui.Region

-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_FontStyles_Shared/SharedFontStyles.xml
-- https://github.com/Gethe/wow-ui-source/blob/5076663b5454de9e7522320994ea7cc15b2a961c/Interface/AddOns/Blizzard_FontStyles_Frame/Mainline/FontStyles.xml
ui.fonts = ns.lua.ToMap({
  "GameFontHighlight", "GameFontHighlightSmall",
  "SystemFont_Med2",
})

local Label = Class(Region, function(self)
  local fontObj, text, color = Drop(self, "fontObj", "text", "color")
  if fontObj then self._widget:SetFontObject(fontObj) end
  if text then self:Text(text) end
  if color then self:Color(unpack(color)) end

  local h, v = Drop(self, 'justifyH', 'justifyV')
  if h then self._widget:SetJustifyH(h) end
  if v then self._widget:SetJustifyV(v) end
end, {
  CreateWidget = function(self)
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
