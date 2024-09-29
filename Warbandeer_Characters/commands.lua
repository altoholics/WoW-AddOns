local _, ns = ...

-- handle slash commands
function ns:SlashCmd(_, msg) -- cmd, msg
  local _, _, cmd = string.find(msg, "(%w+) ?(.*)") --, args
  if cmd == nil then
    ns.wowui.ShowOptionsCategory("Warbandeer_Characters")
  else
    ns.Print("Usage: /wbc")
  end
end
