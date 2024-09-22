local _, ns = ...
local ui = ns.g.ui

-- set up event handling
-- eventually this should keep the frame local and expose register/unregister functions
-- so we can chain callbacks

ns.EventController = ui.Frame:new{}
ns.EventController:listenForEvents()

function ns.EventController:OnEvent(event, ...) -- luacheck: no unused
  if self[event] then
    self[event](self, ...)
  end
end
