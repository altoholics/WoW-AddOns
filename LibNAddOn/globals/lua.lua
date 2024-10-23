local _, ns = ...
-- luacheck: globals unpack table CopyTable Mixin floor AbbreviateNumbers gsub strsub strmatch strupper

local table, tinsert = table, table.insert
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
    destination[k] = v
  end
  return destination
end

local function Merge(destination, ...)
  for i=1,select("#", ...) do
    local t = select(i, ...)
    if t then
      for k, v in pairs(t) do
        if '__index' ~= k then
          if type(destination[k]) == "table" and type(v) == "table" then
            Merge(destination[k], v)
          else
            destination[k] = v
          end
        end
      end
    end
  end
  return destination
end

local function Fill(destination, ...)
  for i=1,select("#", ...) do
    local t = select(i, ...)
    if t then
      for k, v in pairs(t) do
        if destination[k] == nil then
          destination[k] = v
        elseif type(destination[k]) == "table" and type(v) == "table" then
          Fill(destination[k], v)
        end
      end
    end
  end
  return destination
end

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

local function Class(parent, fn, defaults, ...)
  local c = {}
  Merge(c, ...)

  -- define the constructor
  function c:new(o)
    local onLoad = o.onLoad
    o.onLoad = nil
    if defaults then Fill(o, defaults) end
    o = parent and parent:new(o) or o
    Merge(o, parent or {}, c)
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
  tinsert = tinsert,
  tremove = table.remove,
  floor = floor,
  string = string,
  gsub = gsub,
  strsub = strsub,
  strmatch = strmatch,
  strupper = strupper,

  -- WoW lua extensions
  CopyTable = CopyTable,
  Mixin = Mixin, -- Interface/AddOns/Blizzard_SharedXMLBase/Mixin.lua#L6
  -- Interface/AddOns/Blizzard_SharedXMLBase/TableUtil.lua
  AbbreviateNumbers = AbbreviateNumbers,

  -- lua extensions
  min = function(a,b) return a < b and a or b end, -- todo: move to `math`
  max = function(a,b) return a > b and a or b end,

  CopyTables = CopyTables,
  Generate = Generate,
  MergeTable = MergeTable,
  Merge = Merge,
  Fill = Fill,

  -- return a function that transforms a table by selecting the provided key
  Select = function(k) return function(t) return t[k] end end,

  Map = Map,
  ToMap = ToMap,

  Class = Class,
}

function ns.lua.Drop(t, ...)
  local r = {}
  for i=1,select("#", ...) do
    local k = select(i, ...)
    tinsert(r, i, t[k])
    t[k] = nil
  end
  return unpack(r)
end
