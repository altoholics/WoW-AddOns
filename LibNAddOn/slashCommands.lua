local _, ns = ...
-- luacheck: globals SlashCmdList

local _G, SlashCmdList = _G, SlashCmdList

function ns.registerSlashCommands(addOn, slashCommands)
  for base,commands in pairs(slashCommands) do
    base = string.upper(base)
    for i,cmd in ipairs(commands) do
      _G["SLASH_"..base..i] = cmd
    end
    SlashCmdList[base] = function(msg)
      addOn:SlashCmd(base, msg)
    end
  end
end
