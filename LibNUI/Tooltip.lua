local _, ns = ...
local ui = ns.ui

local tinsert = ns.lua.tinsert
local Class, CleanFrame, Frame = ns.lua.Class, ui.CleanFrame, ui.Frame

local Tooltip = Class(CleanFrame, function(self)
  self:Hide()

  local w = 0
  local h = 0
  local lines = self.lines
  self.lines = {}
  for i,line in ipairs(lines) do
    local l = Frame:new{
      parent = self,
      position = {
        TopLeft = i == 1 and {self.inset, -self.inset} or {self.lines[i-1]._widget, ui.edge.BottomLeft},
        Right = {self._widget, ui.edge.Right},
        Height = 20,
      },
      background = line.background,
    }
    l:withLabel({
      text = line.text,
      position = {Fill = {}},
      justifyH = ui.edge.Left,
    })
    w = ns.lua.max(w, l.label._widget:GetUnboundedStringWidth())
    if line.onClick then l._widget:SetScript("OnMouseUp", function() line.onClick(l) end) end
    if line.onEnter then l._widget:SetScript("OnEnter", function() line.onEnter(l) end) end
    if line.onLeave then l._widget:SetScript("OnLeave", function() line.onLeave(l) end) end
    tinsert(self.lines, l)
    h = h + l:Height()
  end
  self:Height(h + 2 * self.inset)
  self:Width(w + 2 * self.inset)
end, {
  strata = "DIALOG",
  background = {0, 0, 0, 0.7},
  inset = 3,
})
ui.Tooltip = Tooltip
