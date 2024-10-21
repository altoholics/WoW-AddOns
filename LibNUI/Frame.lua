local _, ns = ...
local ui = ns.ui

local CreateFrame = ns.wowui.CreateFrame
local UISpecialFrames = ns.wowui.UISpecialFrames
local _G, tinsert = _G, table.insert

local Class, CopyTables, Drop, unpack = ns.lua.Class, ns.lua.CopyTables, ns.lua.Drop, ns.lua.unpack
local Artwork, Background, Overlay = ui.layer.Artwork, ui.layer.Background, ui.layer.Overlay
local Texture, Label = ui.Texture, ui.Label

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

-- empty frame
local Frame = Class(nil, function(self)
  local type, name, parent, template = Drop(self, "type", "name", "parent", "template")
  local strata, clamped, scale, level = Drop(self, "strata", "clamped", "scale", "level")
  self.frame = CreateFrame(type or "Frame", name, parent and parent._element or parent, template)
  self._element = self.frame
  if strata then self._element:SetFrameStrata(strata) end
  if clamped then self._element:SetClampedToScreen(true) end
  if scale then self._element:SetScale(scale) end
  if level then self._element:SetFrameLevel(level) end
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
    _G[self._element:GetName()] = self._element -- put it in the global namespace
    tinsert(UISpecialFrames, self._element:GetName()) -- make it a special frame
  end

  if self.background then
    self:withTextureBackground("background", {
      color = self.background,
      positionAll = true,
    })
  end
  if self.alpha then self.frame:SetAlpha(self.alpha) end

  if self.drag then
    self:makeDraggable()
    self:makeContainerDraggable()
  end
  if self.dragTarget then self:setDragTarget(self.dragTarget.frame or self.dragTarget) end

  local scripts, events, unitEvents = Drop(self, "scripts", "events", "unitEvents")
  if scripts then
    self:RegisterScript(unpack(scripts))
  end
  if events then
    self:listenForEvents()
    for _,e in pairs(events) do
      self.frame:RegisterEvent(e)
    end
  end
  if unitEvents then
    self:listenForEvents()
    for e,u in pairs(unitEvents) do
      self.frame:RegisterUnitEvent(e, unpack(u))
    end
  end
end, nil, ns.PositionableMixin)
ui.Frame = Frame

function Frame:OnEvent(event, ...)
  if self[event] then
    self[event](self, ...)
  end
end

function Frame:PLAYER_ENTERING_WORLD(login, reload)
  if self.OnLogin and (login or reload) then self:OnLogin() end
end

function Frame:all() self.frame:SetAllPoints(); return self end
function Frame:center(...) self.frame:SetPoint(ui.edge.Center, ...); return self end
function Frame:top(...) self.frame:SetPoint(ui.edge.Top, ...); return self end
function Frame:topLeft(...) self.frame:SetPoint(ui.edge.TopLeft, ...); return self end
function Frame:topRight(...) self.frame:SetPoint(ui.edge.TopRight, ...); return self end
function Frame:bottom(...) self.frame:SetPoint(ui.edge.Bottom, ...); return self end
function Frame:bottomLeft(...) self.frame:SetPoint(ui.edge.BottomLeft, ...); return self end
function Frame:bottomRight(...) self.frame:SetPoint(ui.edge.BottomRight, ...); return self end
function Frame:left(...) self.frame:SetPoint(ui.edge.Left, ...); return self end
function Frame:right(...) self.frame:SetPoint(ui.edge.Right, ...); return self end
function Frame:size(x, y) self.frame:SetSize(x, y); return self end
function Frame:width(w)
  if w ~= nil then self.frame:SetWidth(w); return self end
  return self.frame:GetWidth()
end
function Frame:height(h)
  if h ~= nil then self.frame:SetHeight(h); return self end
  return self.frame:GetHeight()
end
function Frame:show() self.frame:Show(); return self end
function Frame:hide() self.frame:Hide(); return self end
function Frame:toggle()
  self.frame:SetShown(not self.frame:IsVisible())
end
function Frame:SetShown(b) self.frame:SetShown(b); return self end

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
function Frame:SetScript(event, handler) self.frame:SetScript(event, handler); return self end
function Frame:listenForEvents()
  if self._listening then return end
  self._listening = true
  local o = self
  self.frame:SetScript("OnEvent", function(_, e, ...) o:OnEvent(e, ...) end)
end
function Frame:registerEvent(event) self.frame:RegisterEvent(event); return self end
function Frame:unregisterEvent(event) self.frame:UnregisterEvent(event); return self end
-- https://wowpedia.fandom.com/wiki/Making_draggable_frames
function Frame:makeDraggable()
  self.frame:SetMovable(true)
  self.frame:EnableMouse(true)
  self.frame:RegisterForDrag("LeftButton")
  return self
end
function Frame:makeContainerDraggable()
  self.frame:SetScript("OnDragStart", function()
    self.frame:StartMoving()
  end)
  self.frame:SetScript("OnDragStop", function()
    self.frame:StopMovingOrSizing()
  end)
  return self
end
function Frame:setDragTarget(target)
  self.frame:SetScript("OnMouseDown", function()
    target:StartMoving()
  end)
  self.frame:SetScript("OnMouseUp", function()
    target:StopMovingOrSizing()
  end)
end

function Frame:startUpdates()
  if self.onUpdate and not self.animating then
    self.animating = true
    local s = self
    self.frame:SetScript("OnUpdate", function(_, elapsed)
      if s.animating then s:onUpdate(elapsed * 1000) end
    end)
  end
end
function Frame:stopUpdates()
  self.frame:SetScript("OnUpdate", nil)
  self.animating = false
end

-- todo, resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames

function Frame:withTexture(name, o)
  if not o then
    o = name
    name = o.name
  end
  o.parent = o.parent or self.frame
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
  o.parent = self.frame
  self[name] = Label:new(o)
  return self
end
