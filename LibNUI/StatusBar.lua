local _, ns = ...

local ui = ns.ui
local Class = ns.util.Class
local Frame = ui.Frame
local BottomLeft, TopLeft, TopRight = ui.edge.BottomLeft, ui.edge.TopLeft, ui.edge.TopRight

local CreateColor = CreateColor

-- https://wowpedia.fandom.com/wiki/Widget_API#StatusBar

local StatusBar = Class(Frame, function(self, o)
    o:addBackdrop(o.backdrop or {})
    local fill = o.fill
    o:withTextureArtwork("fill", {color = fill.color})
    if fill.gradient then
      o.fill.texture:SetGradient(unpack(fill.gradient))
    end
    if fill.blend then o.fill.texture:SetBlendMode("ADD") end
end, {
    type = "StatusBar"
})
ui.StatusBar = StatusBar

function StatusBar:onLoad()
    self.fill.texture:SetPoint(BottomLeft)
    self.fill.texture:SetHeight(self.frame:GetHeight())
end

