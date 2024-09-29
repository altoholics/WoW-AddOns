local _, ns = ...
-- luacheck: globals unpack table CopyTable Mixin

local table = table
local Mixin, setmetatable = Mixin, setmetatable

local function CopyTables(...)
  local copy = {}
  local t
  for i=1,select("#", ...) do
    t = select(i, ...)
    if t then
      for k, v in pairs(t) do
        copy[k] = v
      end
    end
  end
	return copy
end

-- generate an array by calling a function 1..n times with the index
local function Generate(f, n, start)
  local r, a = {}, start or 1
  for i=a,n do table.insert(r, i, f(i)) end
  return r
end

local function MergeTable(destination, source)
  for k, v in pairs(source) do
    destination[k] = v;
  end
  return destination
end

-- return a function that transforms a table by selecting the provided key
local function Select(k) return function(t) return t[k] end end

-- return a new table by transforming each value by the given function
local function Map(t, f)
  local r = {}
  for k,v in pairs(t) do
    r[k] = f and f(v) or v
  end
  return r
end

-- return a new table by transforming each value by the given function
local function ToMap(t, f)
  local r, x = {}, #t
  for i=1,x do r[t[i]] = f and f(t[i]) or t[i] end
  return r
end

local function min(a, b)
  return a < b and a or b
end

local function Class(parent, fn, defaults)
  local c = {}

  -- define the constructor
  function c:new(o)
    local onLoad = o.onLoad
    o.onLoad = nil
    if defaults then
      for k,v in pairs(defaults) do
        if not o[k] then
          o[k] = v
        elseif type(o[k]) == "table" and type(v) == "table" then
          for j,w in pairs(v) do
            if not o[k][j] then o[k][j] = w end
          end
        end
      end
    end
    o = parent and parent:new(o) or o
    Mixin(o, parent or {}, c)
    setmetatable(o, self)
    self.__index = self
    fn(o)
    if parent and parent.onLoad then parent.onLoad(o) end
    if c.onLoad then c.onLoad(o) end
    if onLoad then onLoad(o) end
    return o
  end

  return c
end

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
  min = min, -- todo: move to `math`

  CopyTables = CopyTables,
  Generate = Generate,
  MergeTable = MergeTable,
  Select = Select,
  Map = Map,
  ToMap = ToMap,

  Class = Class,
}

function ns.lua.max(a, b)
  return a > b and a or b
end
