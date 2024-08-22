local _, ns = ...

-- create a util package
ns.util = {}
local u = ns.util

-- return a function that transforms a table by selecting the provided key
function u.Select(k) return function(t) return t[k] end end

-- return a new table by transforming each value by the given function
function u.Map(t, f)
    local r, x = {}, #t
    for i=1,x do r[i] = f(t[i]) end
    return r
end

-- generate an array by calling a function 1..n times with the index
function u.Generate(f, n, start)
    local r, a = {}, start or 1
    for i=a,n do r[i] = f(i) end
    return r
end
