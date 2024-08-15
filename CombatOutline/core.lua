local addOnName, ns = ...

function ns.Print(...) print("|cFF33FF99".. addOnName.. "|r:", ...) end

local f = CreateFrame("Frame")
function f:OnEvent(event, ...)
    if self[event] then
        self[event](self, event, ...)
    end
end
f:SetScript("OnEvent", f.OnEvent)

local defaults = {
}

function f:ADDON_LOADED(event, name)
    if addOnName == name then
        self.db = WarbandeerDB or CopyTable(defaults)
    end
end
f:RegisterEvent("ADDON_LOADED")

function f:PLAYER_REGEN_DISABLED()
    SetCVar("OutlineEngineMode", 1)
end
f:RegisterEvent("PLAYER_REGEN_DISABLED")

function f:PLAYER_REGEN_ENABLED()
    SetCVar("OutlineEngineMode", 0)
end
f:RegisterEvent("PLAYER_REGEN_ENABLED")
