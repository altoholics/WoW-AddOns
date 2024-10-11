local _, ns = ...

local ui = ns.ui
local Class, unpack = ns.lua.Class, ns.lua.unpack
local Frame = ui.Frame
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
  if self.texture then self.frame:SetStatusBarTexture(self.texture) end

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
