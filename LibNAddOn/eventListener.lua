local _, ns = ...
-- luacheck: globals CreateFrame

local getn, tinsert, tremove = ns.lua.table.getn, ns.lua.tinsert, ns.lua.tremove

local function OnEvent(self, e, ...)
  if self[e] and type(self[e]) == "function" then
    self[e](self, ...)
  end
  if self._eventHandlers[e] then
    for _,h in ipairs(self._eventHandlers[e]) do
      h(self, ...)
    end
  end
end

local function RegisterEvent(self, name, handler, idx)
  if not self._eventHandlers[name] then
    self._eventListener:RegisterEvent(name)
    self._eventHandlers[name] = {}
  end
  if handler then
    if idx then
      tinsert(self._eventHandlers[name], idx, handler)
    else
      tinsert(self._eventHandlers[name], handler)
    end
  end
end

local function UnregisterEvent(self, name, handler)
  if handler then
    local idx
    for i,h in ipairs(self._eventHandlers) do
      if h == handler then idx = i; break end
    end
    if idx then tremove(self._eventHandlers[name], idx) end
    if getn(self._eventHandlers[name]) == 0 then
      self._eventListener:UnregisterEvent(name)
      self._eventHandlers[name] = nil
    end
  else
    self._eventListener:UnregisterEvent(name)
    self._eventHandlers[name] = nil
  end
end

function ns.createEventListener(addOn, addOnName)
  local a = addOn
  a._eventListener = ns.wowui.CreateFrame("Frame")
  a._eventHandlers = {}
  a._eventListener.OnEvent = OnEvent
  a.registerEvent = RegisterEvent
  a.unregisterEvent = UnregisterEvent
  a._eventListener:SetScript("OnEvent", function(_, e, ...) addOn._eventListener.OnEvent(a, e, ...) end)

  -- convenience event listeners
  a:registerEvent("ADDON_LOADED", function(self, name)
    if name ~= self._NAME then return end -- we're only interested in the target add-on
    if self.onLoad then self:onLoad() end -- if an onLoad func is defined, call it
    -- if any other supported convenience event handlers are defined, set those up
    if self.onLogin then
      self:registerEvent("PLAYER_ENTERING_WORLD", function(_, login, reload)
        if login or reload then addOn:onLogin() end
      end)
    end
  end)
end
