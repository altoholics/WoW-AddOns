local _, ns = ...

-- set up the shared api namespace and link it into the local one

if not WarbandeerApi then
    -- not local, and thus global (shared)
    WarbandeerApi = {}
end
ns.api = WarbandeerApi
