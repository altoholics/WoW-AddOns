local _, ns = ...

local ui = ns.ui
local Class, Drop, unpack = ns.lua.Class, ns.lua.Drop, ns.lua.unpack
local ScriptRegion = ui.ScriptRegion

local Texture = Class(ScriptRegion, function(self)
  if self.atlas then
    self._widget:SetAtlas(self.atlas, self.atlasSize ~= nil and self.atlasSize or true)
  end
  if self.rotation then self._widget:SetRotation(self.rotation); self.rotation = nil end

  if self.positionAll then self._widget:SetAllPoints() end
  if self.color then self._widget:SetColorTexture(unpack(self.color)); self.color = nil end
  if self.vertexColor then self._widget:SetVertexColor(unpack(self.vertexColor)); self.vertexColor = nil end
  if self.blendMode then self._widget:SetBlendMode(self.blendMode); self.blendMode = nil end
  if self.gradient then self._widget:SetGradient(unpack(self.gradient)); self.gradient = nil end
  if self.clamp then
    for i=1,#self.clamp do
      self._widget:SetPoint(unpack(self.clamp[i]))
    end
  end
  if self.path then
    self._widget:SetTexture(self.path)
  end
  if self.coords then
    self._widget:SetTexCoord(unpack(self.coords))
  end
end, {
  CreateWidget = function(self)
    local parent, name, layer, template = Drop(self, "parent", "name", "layer", "template")
    return (parent._widget or parent):CreateTexture(name or nil, layer or nil, template or nil)
  end,
})
ui.Texture = Texture

function Texture:setTexture(texture) self._widget:SetTexture(texture) end
function Texture:Color(...) self._widget:SetColorTexture(...) end
function Texture:SetVertexColor(...) self._widget:SetVertexColor(...) end
