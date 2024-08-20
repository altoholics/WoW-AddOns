local _, ns = ...

-- set up addon compartment handlers

function Warbandeer_OnAddonCompartmentClick(addonName, buttonName)
    -- addonName = Warbandeer
    -- buttonName = LeftButton | RightButton | MiddleButton
    ns.Open()
end
