local _, ns = ...

local ui = ns.ui
local Class = ns.lua.Class
local Frame = ui.Frame

-- frame with a background
local BgFrame = Class(Frame, function(o)
  o:addBackdrop(o.backdrop or {})
end)
ui.BgFrame = BgFrame
function BgFrame:backdropColor(...) self.backdrop._widget:SetColorTexture(...); return self end
function BgFrame:backdropTexture(...) self.backdrop._widget:SetTexture(...); return self end
