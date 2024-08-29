local _, ns = ...

local CopyTable = CopyTable
local CreateFrame, ShowUIPanel = CreateFrame, ShowUIPanel

local ui = ns.ui
local Class, CopyTables = ns.util.Class, ns.util.CopyTables
local Artwork, Background, Overlay = ui.layer.Artwork, ui.layer.Background, ui.layer.Overlay
local Texture = ui.Texture

-- empty frame
local Frame = Class(nil, function(self, o)
    o.frame = CreateFrame(o.type or "Frame", o.name, o.parent, o.template)
    o.name = nil
    o.parent = nil
    o.template = nil
    if o.position then
        if o.position.width then o:width(o.position.width); o.position.width = nil end
        if o.position.height then o:height(o.position.height); o.position.height = nil end
        for p,args in pairs(o.position) do
            if o[p] then o[p](o, unpack(args)) end
        end
        o.position = nil
    end
    o.frame:SetScript("OnEvent", function(f, e, ...) o:OnEvent(e, ...) end)
    if o.events then
        for _,e in pairs(o.events) do
            o.frame:RegisterEvent(e)
        end
    end
end)
ui.Frame = Frame

function Frame:OnEvent(event, ...)
    if self[event] then
        self[event](self, event, ...)
    end
end

function Frame:center() self.frame:SetPoint(ui.edge.Center); return self end
function Frame:topLeft(...) self.frame:SetPoint(ui.edge.TopLeft, ...); return self end
function Frame:bottomLeft(...) self.frame:SetPoint(ui.edge.BottomLeft, ...); return self end
function Frame:bottomRight(...) self.frame:SetPoint(ui.edge.BottomRight, ...); return self end
function Frame:size(x, y) self.frame:SetSize(x, y); return self end
function Frame:width(w) self.frame:SetWidth(w); return self end
function Frame:height(h) self.frame:SetHeight(h); return self end
function Frame:show() ShowUIPanel(self.frame); return self end
function Frame:hide() HideUIPanel(self.frame); return self end
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
function Frame:startUpdates()
  if self.onUpdate then
    local s = self
    self.frame:SetScript("OnUpdate", function(_, elapsed) s:onUpdate(elapsed) end)
  end
end
function Frame:stopUpdates()
  self.frame:SetScript("OnUpdate", nil)
end

-- todo, resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames

function Frame:withTexture(name, o)
  o.parent = self.frame
  self[name] = Texture:new(o)
  return self
end
function Frame:withTextureBackground(name, o) o.textureLayer = Background; return self:withTexture(name, o) end
function Frame:withTextureArtwork(name, o) o.textureLayer = Artwork; return self:withTexture(name, o) end
function Frame:withTextureOverlay(name, o) o.textureLayer = Overlay; return self:withTexture(name, o) end

local BACKDROP_DEFAULTS = {
    positionAll = true,
    color = {0, 0, 0, 0.8}
}
function Frame:addBackdrop(o)
    return self:withTextureBackground("backdrop", CopyTables(BACKDROP_DEFAULTS, o))
end

