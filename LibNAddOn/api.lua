local _, ns = ...
-- luacheck: globals LibNAddOn

local _G = _G

function ns.print(...) print("|cFF33FF99LibNAddOn|r:", ...) end

function LibNAddOn(features)
  if not features.name then ns.print("missing field name"); return end
  if not features.addOn then ns.print("missing field addOn"); return end
  local addOn = features.addOn
  local addOnName = features.name

  function addOn.Print(...) print("|cFF33FF99".. addOnName.. "|r:", ...) end

  ns.createEventListener(addOn, addOnName)

  if features.db then
    if not features.db.name then ns.print("missing field db.name"); return end
    ns.setupDB(addOnName, addOn, features.db)
  end

  if features.slashCommands then ns.registerSlashCommands(addOn, features.slashCommands) end

  if features.compartmentFn then
    _G[features.compartmentFn] = function(name, buttonName)
      if name ~= addOnName then return end
      -- buttonName = LeftButton | RightButton | MiddleButton
      addOn:CompartmentClick(buttonName)
    end
  end

  ns.linkGlobals(addOn, features)
end
