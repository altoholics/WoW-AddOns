local _, ns = ...
local u = ns.util

-- Interface/AddOns/Blizzard_SharedXMLBase/Mixin.lua#L6
local setmetatable, Mixin = setmetatable, ns.g.Mixin

-- Interface/AddOns/Blizzard_SharedXMLBase/TableUtil.lua
function u.CopyTables(...)
  local copy = {}
  local t
  for i=1,select("#", ...) do
    t = select(i, ...)
    if t then
      for k, v in pairs(t) do
        copy[k] = v;
      end
    end
  end
	return copy;
end

function u.MergeTable(destination, source)
  for k, v in pairs(source) do
    destination[k] = v;
  end
    return destination
end

function u.Class(parent, fn, defaults)
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
          for j,u in pairs(v) do
            if not o[k][j] then o[k][j] = u end
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

-- return a new table by transforming each value by the given function
function u.ToMap(t, f)
  local r, x = {}, #t
  for i=1,x do r[t[i]] = f(t[i]) end
  return r
end
