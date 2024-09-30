local _, ns = ...
local ui = ns.ui

local tinsert = ns.lua.tinsert
local Class, CleanFrame, Frame = ns.lua.Class, ui.CleanFrame, ui.Frame

local Tooltip = Class(CleanFrame, function(self)
  self:hide()

  local w = 0
  local h = 0
  local lines = self.lines
  self.lines = {}
  for i,line in ipairs(lines) do
    local l = Frame:new{
      parent = self,
      position = {
        topLeft = i == 1 and {self.inset, -self.inset} or {self.lines[i-1].frame, ui.edge.BottomLeft},
        right = {self.frame, ui.edge.Right},
        height = 20,
      },
      background = line.background,
    }
    l:withLabel({
      text = line.text,
      position = {fill = {}},
      justifyH = ui.edge.Left,
    })
    w = ns.lua.max(w, l.label.label:GetUnboundedStringWidth())
    if line.onClick then l.frame:SetScript("OnMouseUp", function() line.onClick(l) end) end
    if line.onEnter then l.frame:SetScript("OnEnter", function() line.onEnter(l) end) end
    if line.onLeave then l.frame:SetScript("OnLeave", function() line.onLeave(l) end) end
    tinsert(self.lines, l)
    h = h + l:height()
  end
  self:height(h + 2 * self.inset)
  self:width(w + 2 * self.inset)
end, {
  strata = "DIALOG",
  background = {0, 0, 0, 0.7},
  inset = 3,
})
ui.Tooltip = Tooltip
