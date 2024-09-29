local _, ns = ...
-- luacheck: globals unpack table CopyTable Mixin

local table = table

ns.lua = {
  -- lua
  unpack = unpack,
  table = table,
  tinsert = table.insert,
  tremove = table.remove,

  -- WoW lua extensions
  CopyTable = CopyTable,
  Mixin = Mixin, -- Interface/AddOns/Blizzard_SharedXMLBase/Mixin.lua#L6
  -- Interface/AddOns/Blizzard_SharedXMLBase/TableUtil.lua

  -- lua extensions
  min = ns.min, -- todo: move to `math`

  CopyTables = ns.CopyTables,
  Generate = ns.Generate,
  MergeTable = ns.MergeTable,
  Select = ns.Select,
  Map = ns.Map,
  ToMap = ns.ToMap,

  Class = ns.Class,
}

function ns.lua.max(a, b)
  return a > b and a or b
end
