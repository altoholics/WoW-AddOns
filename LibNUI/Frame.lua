local _, ns = ...

local CreateFrame, ShowUIPanel = CreateFrame, ShowUIPanel

local ui = ns.ui
local Class = ns.util.Class

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
            print(p, unpack(args))
    --         if o[p] then o[p](unpack(args)) end
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
function Frame:makeDraggable()
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")
    return self
end
-- todo, resizable: https://wowpedia.fandom.com/wiki/Making_resizable_frames

function Frame:withTexture(name, o)
    self[name] = self.frame:CreateTexture(o.textureName or nil, o.textureLayer or nil, o.textureTemplate or nil)
end

function Frame:addBackdrop(o)
    self.backdrop = self.frame:CreateTexture(o.textureName or nil, o.textureLayer or nil, o.textureTemplate or nil)
    self.backdrop:SetAllPoints()
    self.backdrop:SetColorTexture(o.r or 0, o.g or 0, o.b or 0, o.alpha or 0.8)
    return self
end

