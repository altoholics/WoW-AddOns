local _, ns = ...

-- set up event handling
-- eventually this should keep the frame local and expose register/unregister functions
-- so we can chain callbacks

local EventController = ns.ui.Frame:new{}

function EventController:OnEvent(event, ...) -- luacheck: no unused
  if ns[event] then
    ns[event](ns, ...)
  end
end

function ns:registerEvent(event) -- luacheck: no unused
  EventController.frame:RegisterEvent(event)
end

function ns:unregisterEvent(event) -- luacheck: no unused
  EventController.frame:UnregisterEvent(event)
end
