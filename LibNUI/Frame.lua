local _, ns = ...
local ui = ns.ui

local CreateFrame = ns.wowui.CreateFrame
local UISpecialFrames = ns.wowui.UISpecialFrames
local _G, tinsert = _G, table.insert

local Class, CopyTables, Drop, unpack = ns.lua.Class, ns.lua.CopyTables, ns.lua.Drop, ns.lua.unpack
local Artwork, Background, Overlay = ui.layer.Artwork, ui.layer.Background, ui.layer.Overlay
local ScriptRegion, Texture, Label = ui.ScriptRegion, ui.Texture, ui.Label

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

-- empty frame
local Frame = Class(ScriptRegion, function(self)
  local strata, clamped, scale, level = Drop(self, "strata", "clamped", "scale", "level")
  if strata then self._widget:SetFrameStrata(strata) end
  if clamped then self._widget:SetClampedToScreen(true) end
  if scale then self._widget:SetScale(scale) end
  if level then self._widget:SetFrameLevel(level) end
  local position, special = Drop(self, "position", "self")
  if position then
    for p,args in pairs(position) do
      if self[p] then
        if type(args) == "table" then
          self[p](self, unpack(args))
        elseif args then
          self[p](self, args)
        end
      end
    end
  end
  if special then
    -- make it closable with Escape key
    _G[self._widget:GetName()] = self._widget -- put it in the global namespace
    tinsert(UISpecialFrames, self._widget:GetName()) -- make it a special frame
  end

  if self.background then
    self:withTextureBackground("background", {
      color = self.background,
      positionAll = true,
    })
  end
  if self.alpha then self._widget:SetAlpha(self.alpha) end

  if self.drag then
    self:makeDraggable()
    self:makeContainerDraggable()
  end
  if self.dragTarget then self:setDragTarget(self.dragTarget._widget or self.dragTarget) end

  local scripts, events, unitEvents = Drop(self, "scripts", "events", "unitEvents")
  if scripts then
    self:RegisterScript(unpack(scripts))
  end
  if events then
    self:listenForEvents()
    for _,e in pairs(events) do
      self._widget:RegisterEvent(e)
    end
  end
  if unitEvents then
    self:listenForEvents()
    for e,u in pairs(unitEvents) do
      self._widget:RegisterUnitEvent(e, unpack(u))
    end
  end
end, {
  CreateWidget = function(self)
    local type, name, parent, template = Drop(self, "type", "name", "parent", "template")
    return CreateFrame(type or "Frame", name, parent and parent._widget or parent, template)
  end,
})
ui.Frame = Frame

function Frame:OnEvent(event, ...)
  if self[event] then
    self[event](self, ...)
  end
end

function Frame:PLAYER_ENTERING_WORLD(login, reload)
  if self.OnLogin and (login or reload) then self:OnLogin() end
end

-- separate func so we don't occlude the varargs (...)
local function scriptHandlerFor(c, e)
  return function(...)
    if c[e] then c[e](c, ...) end
  end
end
function Frame:RegisterScript(...)
  local e
  for i=1,select("#", ...) do
    e = select(i, ...)
    self:SetScript(e, scriptHandlerFor(self, e))
  end
end
function Frame:SetScript(event, handler) self._widget:SetScript(event, handler); return self end
function Frame:listenForEvents()
  if self._listening then return end
  self._listening = true
  local o = self
  self._widget:SetScript("OnEvent", function(_, e, ...) o:OnEvent(e, ...) end)
end
function Frame:registerEvent(event) self._widget:RegisterEvent(event); return self end
function Frame:unregisterEvent(event) self._widget:UnregisterEvent(event); return self end
-- https://wowpedia.fandom.com/wiki/Making_draggable_frames
function Frame:makeDraggable()
  self._widget:SetMovable(true)
  self._widget:EnableMouse(true)
  self._widget:RegisterForDrag("LeftButton")
  return self
end
function Frame:makeContainerDraggable()
  self._widget:SetScript("OnDragStart", function()
    self._widget:StartMoving()
  end)
  self._widget:SetScript("OnDragStop", function()
    self._widget:StopMovingOrSizing()
  end)
  return self
end
function Frame:setDragTarget(target)
  self._widget:SetScript("OnMouseDown", function()
    target:StartMoving()
  end)
  self._widget:SetScript("OnMouseUp", function()
    target:StopMovingOrSizing()
  end)
end

function Frame:startUpdates()
  if self.onUpdate and not self.animating then
    self.animating = true
    local s = self
    self._widget:SetScript("OnUpdate", function(_, elapsed)
      if s.animating then s:onUpdate(elapsed * 1000) end
    end)
  end
end
function Frame:stopUpdates()
  self._widget:SetScript("OnUpdate", nil)
  self.animating = false
end

-- todo, resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames

function Frame:withTexture(name, o)
  if not o then
    o = name
    name = o.name
  end
  o.parent = o.parent or self._widget
  self[name] = Texture:new(o)
  return self
end

function Frame:withTextureBackground(name, o)
  if not o then
    o = name
    name = o.name
  end
  o.layer = Background
  return self:withTexture(name, o)
end
function Frame:withTextureArtwork(name, o)
  if not o then
    o = name
    name = o.name
  end
  o.layer = Artwork
  return self:withTexture(name, o)
end
function Frame:withTextureOverlay(name, o)
  if not o then
    o = name
    name = o.name
  end
  o.layer = Overlay
  return self:withTexture(name, o)
end

local BACKDROP_DEFAULTS = {
  positionAll = true,
  color = {0, 0, 0, 0.8}
}
function Frame:addBackdrop(o)
  o = o or {}
  return self:withTextureBackground(o.name or "backdrop", CopyTables(BACKDROP_DEFAULTS, o))
end

function Frame:withLabel(name, o)
  if not o then
    o = name
    name = o.name or "label"
  end
  o.parent = self._widget
  self[name] = Label:new(o)
  return self
end
