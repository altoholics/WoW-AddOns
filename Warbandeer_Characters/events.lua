local ADDON_NAME, ns = ...

-- set up event handling
-- eventually this should keep the frame local and expose register/unregister functions
-- so we can chain callbacks

local EventController = ns.ui.Frame:new{
  events = {"ADDON_LOADED", "PLAYER_ENTERING_WORLD", "PLAYER_LEVEL_UP"},
  onLoad = function(self)
    self.onLoadCallbacks = {}
  end,
}
ns.EventController = EventController

function EventController:ADDON_LOADED(name)
  if ADDON_NAME ~= name then return end
  for _,c in ipairs(self.onLoadCallbacks) do
    c(ns)
  end
end

function ns.onLoad(fn) table.insert(EventController.onLoadCallbacks, fn) end
