local _, ns = ...
-- luacheck: globals CreateFrame

function ns.createEventListener(addOn)
  addOn._eventListener = CreateFrame("Frame")
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
  function addOn:registerEvent(name, handler)
    if not addOn._eventHandlers[name] then
      addOn._eventListener:RegisterEvent(name)
      addOn._eventHandlers[name] = {}
    end
    if handler then
      table.insert(addOn._eventHandlers, handler)
    end
  end
  function addOn:unregisterEvent(name, handler)
    if handler then
      local idx
      for i,h in ipairs(addOn._eventHandlers) do
        if h == handler then idx = i; break end
      end
      if idx then table.remove(addOn._eventHandlers[name], idx) end
      if table.getn(addOn._eventHandlers[name]) == 0 then
        addOn._eventListener:UnregisterEvent(name)
        addOn._eventHandlers[name] = nil
      end
    else
      addOn._eventListener:UnregisterEvent(name)
      addOn._eventHandlers[name] = nil
    end
  end
  addOn._eventListener:SetScript("OnEvent", function(_, e, ...) addOn._eventListener:OnEvent(e, ...) end)
end
