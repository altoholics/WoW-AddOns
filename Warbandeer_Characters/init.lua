local addOnName, ns = ...

-- any initial setup for the addon will go here
-- including some basic shared functions

function ns.Print(...) print("|cFF33FF99".. addOnName.. "|r:", ...) end

-- https://wowpedia.fandom.com/wiki/Category:HOWTOs
-- addon compartment, settings scroll templates: https://warcraft.wiki.gg/wiki/Patch_10.1.0/API_changes
-- settings changes: https://warcraft.wiki.gg/wiki/Patch_11.0.2/API_changes

-- function f:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
    -- false/false when transitioning (portal, etc)
    -- ns.Print(event, isLogin, isReload)
    -- on isLogin, scan character info?
-- end
-- f:RegisterEvent("PLAYER_ENTERING_WORLD")

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Options_Panel
