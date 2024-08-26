local _, ns = ...

local ui = ns.ui
local Class = ns.util.Class
local Frame = ui.Frame

-- https://wowpedia.fandom.com/wiki/Widget_API#StatusBar

local StatusBar = Class(Frame, function(self, o)
    o:addBackdrop(o.backdrop or {})
    if o.fillColor then
        o.fillColor = nil
    end
end, {
    type = "StatusBar"
})
ui.StatusBar = StatusBar
