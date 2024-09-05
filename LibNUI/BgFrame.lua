local _, ns = ...

local ui = ns.ui
local Class = ns.util.Class
local Frame = ui.Frame

-- frame with a background
local BgFrame = Class(Frame, function(o)
    o:addBackdrop(o.backdrop or {})
end)
ui.BgFrame = BgFrame
function BgFrame:backdropColor(...) self.backdrop.texture:SetColorTexture(...); return self end
function BgFrame:backdropTexture(...) self.backdrop.texture:SetTexture(...); return self end
