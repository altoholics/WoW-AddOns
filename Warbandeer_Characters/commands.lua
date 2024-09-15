local _, ns = ...

-- handle slash commands

-- https://wowpedia.fandom.com/wiki/Create_a_WoW_AddOn_in_15_Minutes#Slash_commands

local function listCharacters(t)
  local c = {}
  for _,data in pairs(t) do
    table.insert(c, data)
  end
  table.sort(c, function(c1, c2)
    return c1 ~= nil and c2 ~= nil and c1.level >= c2.level and c1.ilvl >= c2.ilvl and c1.name > c2.name
  end)
  for _,d in ipairs(c) do
    print(d.name, d.level, d.race, d.className, "ilvl "..d.ilvl)
  end
end

function ns:SlashCmd(_, msg) -- cmd, msg
  local _, _, cmd = string.find(msg, "(%w+) ?(.*)") --, args
  if cmd == nil then
    ns.g.ShowOptionsCategory("Warbandeer_Characters")
  elseif "list" == cmd then
    listCharacters(self.db.characters)
  else
    ns.Print("Usage: /wbc [list]")
  end
end
