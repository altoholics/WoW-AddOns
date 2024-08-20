local _, ns = ...

-- set up addon compartment handlers

function Warbandeer_OnAddonCompartmentClick(addonName, buttonName)
    ns.Print("OnAddonCompartmentClick", addonName, buttonName)
    ns.Open()
end
