local _, ns = ...

local ui = ns.ui
local Class, unpack, Mixin = ns.lua.Class, ns.lua.unpack, ns.lua.Mixin
local Frame, Texture = ui.Frame, ui.Texture
local BottomLeft = ui.edge.BottomLeft

-- https://wowpedia.fandom.com/wiki/Widget_API#StatusBar

local StatusBar = Class(Frame, function(self)
  if self.backdrop then self:addBackdrop(self.backdrop) end

  if self.fill then
    local fill = self.fill
    self:withTextureArtwork("fill", {color = fill.color})
    if fill.gradient then self.fill.texture:SetGradient(ns.lua.unpack(fill.gradient)) end
    if fill.blend then self.fill.texture:SetBlendMode("ADD") end
  end
  if self.color then self.frame:SetColorFill(unpack(self.color)) end

  if self.texture then
    if type(self.texture) == "table" then
      local tex = Texture:new(Mixin({
        parent = self,
      }, self.texture))
      self.frame:SetStatusBarTexture(tex.texture)
      tex.texture:ClearAllPoints()
      tex:top(self.frame)
      tex:left(self.frame)
      tex:right(self.frame)
      tex:bottom(self.frame)
      local l, r, t, b = unpack(self.texture.coords or {0, 1, 0, 1})
      self.X1 = l
      self.X2 = r
      self.Xd = r - l
      self.Y1 = t
      self.Y2 = b
      self.Yd = b - t
      self.texture = tex
    else
      self.frame:SetStatusBarTexture(self.texture)
      self.texture = nil
    end
  end

  if self.orientation then self.frame:SetOrientation(self.orientation) end
  if self.min and self.max then self.frame:SetMinMaxValues(self.min, self.max) end
end, {
  type = "StatusBar"
})
ui.StatusBar = StatusBar

function StatusBar:onLoad()
  if self.fill then
    self.fill.texture:SetPoint(BottomLeft)
    self.fill.texture:SetHeight(self.frame:GetHeight())
  end
end

function StatusBar:Color(c) self.frame:SetColorFill(unpack(c)) end
function StatusBar:Texture(t) self.frame:SetStatusBarTexture(t) end

function StatusBar:SetValue(v)
  if not self.texture then self.frame:SetValue(v); return end
  local n, m = self.frame:GetMinMaxValues()
  local p = 1 - (v / (m-n))
  local dx, dy = self.Xd * p, self.Yd * p
  local l, r, t, b = self.X1, self.X2, self.Y1, self.Y2
  if self.frame:GetOrientation() == "horizontal" then
    if dx > 0 then -- luacheck: ignore
      --
    end
  else -- vertical
    -- bottom up
    t = t + dy
    self.texture:top(0, self:height() * -dy)
  end
  self.texture.texture:SetTexCoord(l, r, t, b)
end
