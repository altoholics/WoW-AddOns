local _, ns = ...

local ui = ns.ui
local Class = ns.lua.Class

local Texture = Class(nil, function(o)
    o.texture = o.parent:CreateTexture(o.textureName or nil, o.textureLayer or nil, o.textureTemplate or nil)
    o.textureName = nil
    o.textureLayer = nil
    o.textureTemplate = nil

    if o.positionAll then o.texture:SetAllPoints() end
    if o.color then o.texture:SetColorTexture(unpack(o.color)); o.color = nil end
    if o.blendMode then o.texture:SetBlendMode(o.blendMode); o.blendMode = nil end
    if o.gradient then o.texture:SetGradient(unpack(o.gradient)); o.gradient = nil end
    if o.clamp then
      for i=1,#o.clamp do
        o.texture:SetPoint(unpack(o.clamp[i]))
      end
    end
    if o.texturePath then
      o.texture:SetTexture(o.texturePath)
    end
    if o.coords then
      o.texture:SetTexCoord(unpack(o.coords))
    end
end)
ui.Texture = Texture

function Texture:setTexture(texture)
  self.texture:SetTexture(texture)
end

function Texture:Color(r, g, b, a) self.texture:SetColorTexture(r, g, b, a) end
