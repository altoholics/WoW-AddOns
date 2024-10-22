local _, ns = ...

local ui = ns.ui
local Class, Drop, unpack = ns.lua.Class, ns.lua.Drop, ns.lua.unpack
local Region = ui.Region

local Texture = Class(Region, function(self)
  if self.atlas then
    self._widget:SetAtlas(self.atlas, self.atlasSize ~= nil and self.atlasSize or true)
  end
  if self.rotation then self._widget:SetRotation(self.rotation); self.rotation = nil end

  local color, vertexColor, blendMode, gradient = Drop(self, 'color', 'vertexColor', 'blendMode', 'gradient')
  if color then self:Color(unpack(color)) end
  if vertexColor then self:SetVertexColor(unpack(vertexColor)) end
  if blendMode then self._widget:SetBlendMode(blendMode) end
  if gradient then self._widget:SetGradient(unpack(gradient)) end

  local path, coords = Drop(self, 'path', 'coords')
  if path then self:Texture(path) end
  if coords then self:Coords(unpack(coords)) end
end, {
  CreateWidget = function(self)
    local parent, name, layer, template = Drop(self, "parent", "name", "layer", "template")
    return (parent._widget or parent):CreateTexture(name or nil, layer or nil, template or nil)
  end,
})
ui.Texture = Texture

function Texture:Texture(texture) self._widget:SetTexture(texture) end
function Texture:Color(...) self._widget:SetColorTexture(...) end
function Texture:SetVertexColor(...) self._widget:SetVertexColor(...) end
function Texture:Coords(...) self._widget:SetTexCoord(...) end
