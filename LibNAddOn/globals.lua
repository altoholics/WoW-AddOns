local _, ns = ...

function ns.linkGlobals(addOn, features)
  addOn[features.lua or "lua"] = ns.lua
  addOn[features.wow or "wow"] = ns.wow
  addOn[features.wowui or "wowui"] = ns.wowui
end
