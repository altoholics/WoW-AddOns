local _, ns = ...

local ui = ns.ui
local Class, unpack = ns.lua.Class, ns.lua.unpack
local Region = ui.Region

local Texture = Class(Region, function(self)
  if self.atlas then
    self._widget:SetAtlas(self.atlas, self.atlasSize ~= nil and self.atlasSize or true)
  end
  if self.rotation then self._widget:SetRotation(self.rotation); self.rotation = nil end

  if self.color then self:Color(unpack(self.color)) end
  if self.vertexColor then self:SetVertexColor(unpack(self.vertexColor)) end
  if self.blendMode then self._widget:SetBlendMode(self.blendMode) end
  if self.gradient then self._widget:SetGradient(unpack(self.gradient)) end

  if self.path then self:Texture(self.path) end
  if self.coords then self:Coords(unpack(self.coords)) end
end, {
  CreateWidget = function(self)
    return (self.parent._widget or self.parent):CreateTexture(self.name, self.layer, self.template)
  end,
})
ui.Texture = Texture

function Texture:Texture(texture) self._widget:SetTexture(texture) end
function Texture:Color(...) self._widget:SetColorTexture(...) end
function Texture:SetVertexColor(...) self._widget:SetVertexColor(...) end
function Texture:Coords(...) self._widget:SetTexCoord(...) end
