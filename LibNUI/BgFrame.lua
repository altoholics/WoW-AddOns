local _, ns = ...

local ui = ns.ui
local Class = ns.util.Class
local Frame = ui.Frame

-- frame with a background
local BgFrame = Class(Frame, function(self, o)
    o:addBackdrop(o.backdrop or {})
end)
ui.BgFrame = BgFrame
function BgFrame:backdropColor(...) self.backdrop:SetColorTexture(...); return self end
function BgFrame:backdropTexture(...) self.backdrop:SetTexture(...); return self end
