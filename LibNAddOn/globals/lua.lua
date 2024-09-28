local _, ns = ...
-- luacheck: globals CopyTable Mixin

ns.lua = {
  -- lua
  unpack = unpack,

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
