local _, ns = ...
local ui = ns.ui
local Class, UIParent = ns.lua.Class, ns.wowui.UIParent
local Frame, Label = ui.Frame, ui.Label
local strmatch = ns.lua.strmatch

local ActivityMonitor = Class(Frame, function(self)
  self.recent = Label:new{
    parent = self,
    position = {
      TopLeft = {},
      BottomRight = {}
    },
  }
end, {
  parent = UIParent,
  name = "ShadowUIActivityMonitor",
  position = {
    Width = 100,
    Height = 16,
    BottomLeft = {20, 325},
  },
  events = {'BN_FRIEND_ACCOUNT_ONLINE', 'BN_FRIEND_ACCOUNT_OFFLINE', 'CHAT_MSG_SYSTEM'},
})
ns.ActivityMonitor = ActivityMonitor

function ActivityMonitor:CHAT_MSG_SYSTEM(text)
  if strmatch(text, '^(.+) has come online.$') then -- Name-Realm name is linked
    self.recent:Text(text)
  elseif strmatch(text, '^[%w-]+ has gone offline.$') then
    self.recent:Text(text)
  end
end
