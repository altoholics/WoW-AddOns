local _, ns = ...
local ui = ns.ui
local Class, UIParent = ns.lua.Class, ns.wowui.UIParent
local Frame, Button, Label = ui.Frame, ui.Button, ui.Label
local strmatch, tinsert, tremove, unpack = ns.lua.strmatch, ns.lua.tinsert, ns.lua.tremove, ns.lua.unpack

local ActivityButton = Class(Button, function(self)
  self.label = Label:new{
    parent = self,
    position = {
      All = true,
    },
  }
end, {
  position = {
    Width = 21,
    Height = 16,
    Alpha = 0,
  },
})

function ActivityButton:Text(text)
  self.label:Text(text)
end

function ActivityButton:Play()
  self.anim:Play()
end

function ActivityButton:Online(name)
  self.label:Text(name)
  self.label:Color(unpack(ns.Color.Green))
  self:Alpha(1)
  self:Play()
end

function ActivityButton:Offline(name)
  self.label:Text(name)
  self.label:Color(unpack(ns.Color.DullRed))
  self:Alpha(1)
  self:Play()
end

local ActivityMonitor = Class(Frame, function(self)
  local m = self
  self.anim = self._widget:CreateAnimationGroup()
  self.anim:SetToFinalAlpha(true)

  self.names = {}
  for i=1,4 do
    local fade = self.anim:CreateAnimation('Alpha')
    fade:SetStartDelay(5)
    fade:SetDuration(10)
    fade:SetFromAlpha(1)
    fade:SetToAlpha(0)
    tinsert(self.names, ActivityButton:new{
      parent = self,
      position = {
        Left = i == 1 and {self, ui.edge.Left} or {self.names[i-1], ui.edge.Right, 4, 0},
      },
      anim = fade,
    })
    fade:SetScript("OnFinished", m.OnFinished)
    fade:SetParent(self.names[i]._widget)
  end
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

function ActivityMonitor:OnFinished(anim)
  local w = anim:GetParent()
  local idx
  for i,b in ipairs(self.names) do
    if b._widget == w then
      idx = i
    end
  end
  if idx == 1 then
    self.names[2]:Left(self, ui.edge.Left)
  else
    self.names[idx+1]:Left(self.names[idx-1], ui.edge.Right, 4, 0)
  end
  local b = tremove(self.names, idx)
  tinsert(self.names, b)
end

function ActivityMonitor:GetNext()
  for i=1,4 do
    if self.names[i]:Alpha() == 0 then return self.names[i] end
  end
end

function ActivityMonitor:CHAT_MSG_SYSTEM(text)
  local link = strmatch(text, '^(.+) has come online.$')
  if link then -- Name-Realm name is linked
    print(text)
    print(link)
    local next = self:GetNext()
    if next then
      next:Online(link)
    end
  elseif strmatch(text, '^([%w-\']+) has gone offline.$') then
    print(text)
    local next = self:GetNext()
    if next then
      next:Offline(link)
    end
  end
end
