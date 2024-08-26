local _, ns = ...

local ui = ns.ui
local Class = ns.util.Class

local Texture = Class(nil, function(self, o)
    o.texture = o.parent:CreateTexture(o.textureName or nil, o.textureLayer or nil, o.textureTemplate or nil)
    o.textureName = nil
    o.textureLayer = nil
    o.textureTemplate = nil

    if o.positionAll then
        o.texture:SetAllPoints()
    end
    if o.color then
        o.texture:SetColorTexture(unpack(o.color))
    end
end)
ui.Texture = Texture
