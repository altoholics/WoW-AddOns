local _, ns = ...
-- luacheck: globals LibNAddOn

function ns.print(...) print("|cFF33FF99LibNAddOn|r:", ...) end

function LibNAddOn(features)
  if not features.name then ns.print("missing field name"); return end
  if not features.addOn then ns.print("missing field addOn"); return end
  local addOn = features.addOn
  local addOnName = features.name

  function addOn.Print(...) print("|cFF33FF99".. addOnName.. "|r:", ...) end

  ns.createEventListener(addOn)

  if features.db then
    if not features.db.name then ns.print("missing field db.name"); return end
    ns.setupDB(addOnName, addOn, features.db)
  end
end
