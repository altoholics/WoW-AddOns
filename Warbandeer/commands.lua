local _, ns = ...

-- set up slash command defintions and handlers

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Slash_commands
SLASH_WARBAND1 = "/warband"
SLASH_WARBAND2 = "/wb"

function SlashCmdList.WARBAND(msg)
    ns.Open()
end
