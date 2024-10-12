local _, ns = ...

local ui = ns.ui
local Class, unpack = ns.lua.Class, ns.lua.unpack

local Texture = Class(nil, function(o)
    o.texture = (o.parent.frame or o.parent):CreateTexture(o.name or nil, o.layer or nil, o.template or nil)
    o.name = nil
    o.layer = nil
    o.template = nil

    if o.atlas then
      o.texture:SetAtlas(o.atlas, o.atlasSize ~= nil and o.atlasSize or true)
    end

    if o.positionAll then o.texture:SetAllPoints() end
    if o.color then o.texture:SetColorTexture(unpack(o.color)); o.color = nil end
    if o.vertexColor then o.texture:SetVertexColor(unpack(o.vertexColor)); o.vertexColor = nil end
    if o.blendMode then o.texture:SetBlendMode(o.blendMode); o.blendMode = nil end
    if o.gradient then o.texture:SetGradient(unpack(o.gradient)); o.gradient = nil end
    if o.clamp then
      for i=1,#o.clamp do
        o.texture:SetPoint(unpack(o.clamp[i]))
      end
    end
    if o.position then
      for p,args in pairs(o.position) do
        if o[p] then
          if type(args) == "table" then
            o[p](o, unpack(args))
          elseif args then
            o[p](o, args)
          end
        end
      end
      o.position = nil
    end
    if o.path then
      o.texture:SetTexture(o.path)
    end
    if o.coords then
      o.texture:SetTexCoord(unpack(o.coords))
    end
end)
ui.Texture = Texture

function Texture:center(...) self.texture:SetPoint(ui.edge.Center, ...); return self end
function Texture:top(...) self.texture:SetPoint(ui.edge.Top, ...); return self end
function Texture:topLeft(...) self.texture:SetPoint(ui.edge.TopLeft, ...); return self end
function Texture:topRight(...) self.texture:SetPoint(ui.edge.TopRight, ...); return self end
function Texture:bottom(...) self.texture:SetPoint(ui.edge.Bottom, ...); return self end
function Texture:bottomLeft(...) self.texture:SetPoint(ui.edge.BottomLeft, ...); return self end
function Texture:bottomRight(...) self.texture:SetPoint(ui.edge.BottomRight, ...); return self end
function Texture:left(...) self.texture:SetPoint(ui.edge.Left, ...); return self end
function Texture:right(...) self.texture:SetPoint(ui.edge.Right, ...); return self end
function Texture:size(x, y) self.texture:SetSize(x, y); return self end
function Texture:width(w)
  if w ~= nil then self.texture:SetWidth(w); return self end
  return self.texture:GetWidth()
end
function Texture:height(h)
  if h ~= nil then self.texture:SetHeight(h); return self end
  return self.texture:GetHeight()
end
function Texture:show() self.texture:Show(); return self end
function Texture:hide() self.texture:Hide(); return self end
function Texture:toggle()
  self.texture:SetShown(not self.texture:IsVisible())
end
function Texture:SetShown(b) self.texture:SetShown(b); return self end

function Texture:setTexture(texture)
  self.texture:SetTexture(texture)
end

function Texture:Color(r, g, b, a) self.texture:SetColorTexture(r, g, b, a) end
