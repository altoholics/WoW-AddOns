local _, ns = ...
local ui = ns.ui

local CreateFrame = ns.wowui.CreateFrame
local UISpecialFrames = ns.wowui.UISpecialFrames
local _G, tinsert = _G, table.insert

local Class, CopyTables, unpack = ns.lua.Class, ns.lua.CopyTables, ns.lua.unpack
local Artwork, Background, Overlay = ui.layer.Artwork, ui.layer.Background, ui.layer.Overlay
local Texture, Label = ui.Texture, ui.Label

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

-- empty frame
local Frame = Class(nil, function(o)
  o.frame = CreateFrame(o.type or "Frame", o.name, o.parent and o.parent.frame or o.parent, o.template)
  o.name = nil
  o.parent = nil
  o.template = nil
  if o.strata then
    o.frame:SetFrameStrata(o.strata)
    o.strata = nil
  end
  if o.clamped then
    o.frame:SetClampedToScreen(true)
    o.clamped = nil
  end
  if o.scale then
    o.frame:SetScale(o.scale)
    o.scale = nil
  end
  if o.level then
    o.frame:SetFrameLevel(o.level)
    o.level = nil
  end
  if o.position then
    for p,args in pairs(o.position) do
      if o[p] then
        if type(args) == "table" then
          o[p](o, unpack(args))
        elseif args then
          o[p](o, args)
        end
      end
    end
    o.position = nil
  end
  if o.special then
    -- make it closable with Escape key
    _G[o.frame:GetName()] = o.frame -- put it in the global namespace
    tinsert(UISpecialFrames, o.frame:GetName()) -- make it a special frame
  end
  if o.background then
    o:withTextureBackground("background", {
      color = o.background,
      positionAll = true,
    })
  end
  if o.drag then
    o:makeDraggable()
    o:makeContainerDraggable()
  end
  if o.dragTarget then o:setDragTarget(o.dragTarget.frame or o.dragTarget) end

  if o.events then
    if not o._listening then o:listenForEvents() end
    for _,e in pairs(o.events) do
      o.frame:RegisterEvent(e)
    end
  end
  if o.unitEvents then
    if not o._listening then o:listenForEvents() end
    for e,u in pairs(o.unitEvents) do
      o.frame:RegisterUnitEvent(e, unpack(u))
    end
  end
end)
ui.Frame = Frame

function Frame:OnEvent(event, ...)
  if self[event] then
    self[event](self, ...)
  end
end

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
function Frame:listenForEvents()
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
    self.frame:SetScript("OnUpdate", function(_, elapsed) s:onUpdate(elapsed * 1000) end)
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
