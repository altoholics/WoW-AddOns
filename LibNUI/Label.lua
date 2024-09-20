local _, ns = ...
local ui = ns.ui

local Class = ns.util.Class

ui.fonts = ns.util.ToMap({
  "GameFontHighlight", "GameFontHighlightSmall",
  "SystemFont_Med2",
})

local Label = Class(nil, function(o)
  local l = o.parent:CreateFontString(o.name, o.layer, o.font)
  o.label = l
  o.name = nil
  o.layer = nil
  o.font = nil
  if o.text then
    l:SetText(o.text)
  end
  if o.position then
    for p,args in pairs(o.position) do
      if o[p] then
        if type(args) == "table" then
          o[p](o, unpack(args))
        else
          o[p](o, args)
        end
      end
    end
    o.position = nil
  end
  if o.color then
    l:SetTextColor(unpack(o.color))
  end
  if o.justifyH then
    l:SetJustifyH(o.justifyH)
  end
  if o.justiftV then
    l:SetJustifyV(o.justiftV)
  end
end, {
  layer = ui.layer.Artwork,
  font = ui.fonts.GameFontHighlight
})
ui.Label = Label

function Label:center() self.label:SetPoint(ui.edge.Center); return self end
function Label:topLeft(...) self.label:SetPoint(ui.edge.TopLeft, ...); return self end
function Label:topRight(...) self.label:SetPoint(ui.edge.TopRight, ...); return self end
function Label:bottomLeft(...) self.label:SetPoint(ui.edge.BottomLeft, ...); return self end
function Label:bottomRight(...) self.label:SetPoint(ui.edge.BottomRight, ...); return self end
function Label:left(...) self.label:SetPoint(ui.edge.Left, ...); return self end
function Label:right(...) self.label:SetPoint(ui.edge.Right, ...); return self end
function Label:size(x, y) self.label:SetSize(x, y); return self end
function Label:width(w) self.label:SetWidth(w); return self end
function Label:height(h) self.label:SetHeight(h); return self end