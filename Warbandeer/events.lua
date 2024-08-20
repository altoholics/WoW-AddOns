local _, ns = ...

-- set up event handling
-- eventually this should keep the frame local and expose register/unregister functions
-- so we can chain callbacks

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(event, ...)
    if f[event] then
        f[event](f, event, ...)
    end
end)
ns.frame = f
