local addOnName, ns = ...

-- define the addon database and its defaults

local defaults = {
}

function ns.frame:ADDON_LOADED(event, name)
    if addOnName == name then
        WarbandeerDB = WarbandeerDB or CopyTable(defaults)
        self.db = WarbandeerDB
    end
end
ns.frame:RegisterEvent("ADDON_LOADED")
