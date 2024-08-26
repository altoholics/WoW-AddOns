local _, ns = ...
local u = ns.util

local setmetatable, MergeTable, Mixin = setmetatable, MergeTable, Mixin

function u.Class(parent, fn, defaults)
    local c = {}

    -- define the constructor
    function c:new(o)
        if defaults then MergeTable(o, defaults) end
        o = parent and parent:new(o) or (o or {})
        Mixin(o, parent or {}, c)
        setmetatable(o, self)
        self.__index = self
        fn(self, o)
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
