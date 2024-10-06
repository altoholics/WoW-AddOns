local _, ns = ...

-- handle slash commands
function ns:SlashCmd(_, msg) -- cmd, msg
  local _, _, cmd = string.find(msg, "(%w+) ?(.*)") --, args
  if cmd == nil then
    -- ns:OpenSettings()
  else
    ns.Print("Usage: /wbc")
  end
end
