local _, ns = ...
-- luacheck: globals CreateFrame

local getn, tinsert, tremove = ns.lua.table.getn, ns.lua.tinsert, ns.lua.tremove

function ns.createEventListener(addOn, addOnName)
  addOn._eventListener = ns.wowui.CreateFrame("Frame")
  addOn._eventHandlers = {}
  function addOn._eventListener:OnEvent(e, ...)
    if addOn[e] and type(addOn[e]) == "function" then
      addOn[e](addOn, ...)
    end
    if addOn._eventHandlers[e] then
      for _,h in ipairs(addOn._eventHandlers) do
        h(addOn, ...)
      end
    end
  end
  function addOn:registerEvent(name, handler, idx)
    if not addOn._eventHandlers[name] then
      addOn._eventListener:RegisterEvent(name)
      addOn._eventHandlers[name] = {}
    end
    if handler then
      if idx then
        tinsert(addOn._eventHandlers, idx, handler)
      else
        tinsert(addOn._eventHandlers, handler)
      end
    end
  end
  function addOn:unregisterEvent(name, handler)
    if handler then
      local idx
      for i,h in ipairs(addOn._eventHandlers) do
        if h == handler then idx = i; break end
      end
      if idx then tremove(addOn._eventHandlers[name], idx) end
      if getn(addOn._eventHandlers[name]) == 0 then
        addOn._eventListener:UnregisterEvent(name)
        addOn._eventHandlers[name] = nil
      end
    else
      addOn._eventListener:UnregisterEvent(name)
      addOn._eventHandlers[name] = nil
    end
  end
  addOn._eventListener:SetScript("OnEvent", function(_, e, ...) addOn._eventListener:OnEvent(e, ...) end)

  -- convenience event listeners
  addOn:registerEvent("ADDON_LOADED", function(self, name)
    if name ~= addOnName then return end -- we're only interested in the target add-on
    if addOn.onLoad then addOn:onLoad() end -- if an onLoad func is defined, call it
    -- if any other supported convenience event handlers are defined, set those up
    if addOn.onLogin then
      addOn:registerEvent("PLAYER_ENTERING_WORLD", function(_, login, reload)
        if login or reload then addOn:onLogin() end
      end)
    end
  end)
end
