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
    -- todo: setting for what to set the outline to during combat
}

function f:ADDON_LOADED(event, name)
    if addOnName == name then
        -- NOTE: don't use same global or it'll conflict
        -- also for it to be available it needs to be listed in the .toc
        self.db = WarbandeerDB or CopyTable(defaults)
    end
end
f:RegisterEvent("ADDON_LOADED")

function f:PLAYER_REGEN_DISABLED()
    -- todo: save current cvar values and restore them on leave combat
    SetCVar("OutlineEngineMode", 1)
end
f:RegisterEvent("PLAYER_REGEN_DISABLED")

function f:PLAYER_REGEN_ENABLED()
    SetCVar("OutlineEngineMode", 0)
end
f:RegisterEvent("PLAYER_REGEN_ENABLED")
