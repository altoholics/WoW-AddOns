local _, ns = ...

local ui = ns.ui
local Class, unpack = ns.lua.Class, ns.lua.unpack

local Texture = Class(nil, function(self)
  self.texture = (self.parent.frame or self.parent):CreateTexture(
    self.name or nil, self.layer or nil, self.template or nil
  )
  self.name = nil
  self.layer = nil
  self.template = nil

  if self.atlas then
    self.texture:SetAtlas(self.atlas, self.atlasSize ~= nil and self.atlasSize or true)
  end
  if self.rotation then self.texture:SetRotation(self.rotation); self.rotation = nil end

  if self.positionAll then self.texture:SetAllPoints() end
  if self.color then self.texture:SetColorTexture(unpack(self.color)); self.color = nil end
  if self.vertexColor then self.texture:SetVertexColor(unpack(self.vertexColor)); self.vertexColor = nil end
  if self.blendMode then self.texture:SetBlendMode(self.blendMode); self.blendMode = nil end
  if self.gradient then self.texture:SetGradient(unpack(self.gradient)); self.gradient = nil end
  if self.clamp then
    for i=1,#self.clamp do
      self.texture:SetPoint(unpack(self.clamp[i]))
    end
  end
  if self.position then
    for p,args in pairs(self.position) do
      if self[p] then
        if type(args) == "table" then
          self[p](self, unpack(args))
        elseif args then
          self[p](self, args)
        end
      end
    end
    self.position = nil
  end
  if self.path then
    self.texture:SetTexture(self.path)
  end
  if self.coords then
    self.texture:SetTexCoord(unpack(self.coords))
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
