local addOnName, ns = ...

function ns.Print(...) print("|cFF33FF99".. addOnName.. "|r:", ...) end

local f = CreateFrame("Frame")
function f:OnEvent(event, ...)
    if self[event] then
        self[event](self, event, ...)
    end
end
f:SetScript("OnEvent", f.OnEvent)

function ns.Open() ns.Print("open main window") end

local LDB = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")

local defaults = {
    minimap = {}
}

function f:ADDON_LOADED(event, name)
    if addOnName == name then
        ns.Print(event, name, addOnName)
    
        self.db = WarbandeerDB or CopyTable(defaults)

        local LDBObj = LDB:NewDataObject(addOnName, {
            type = "launcher",
            label = addOnName,
            text = addOnName,
            icon = "Interface\\Icons\\INV_Drink_05",
            tocname = addOnName, -- Required by Diagnostics
            OnClick = ns.Open,
        })
        icon:Register(addOnName, LDBObj, self.db.minimap)
    end
end
f:RegisterEvent("ADDON_LOADED")

function f:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
    -- false/false when transitioning (portal, etc)
    -- ns.Print(event, isLogin, isReload)
end
f:RegisterEvent("PLAYER_ENTERING_WORLD")

function Warbandeer_OnAddonCompartmentClick(addonName, buttonName)
    ns.Print("OnAddonCompartmentClick", addonName, buttonName)
end
