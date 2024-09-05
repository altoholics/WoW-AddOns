local _, ns = ...

-- handle slash commands

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Slash_commands

function ns.SlashCmd() -- cmd, msg
  ns.g.ShowOptionsCategory("Warbandeer_Characters")
end
