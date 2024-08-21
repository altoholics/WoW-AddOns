local addOnName, ns = ...

-- define the addon database and its defaults

local defaults = {
}

function ns.frame:ADDON_LOADED(event, name)
    if addOnName == name then
        self.db = WarbandeerDB or CopyTable(defaults)
    end
end
ns.frame:RegisterEvent("ADDON_LOADED")
