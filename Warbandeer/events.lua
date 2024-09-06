local _, ns = ...

-- set up event handling
-- eventually this should keep the frame local and expose register/unregister functions
-- so we can chain callbacks

ns.EventController = ns.ui.Frame:new{}
