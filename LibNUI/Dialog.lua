local _, ns = ...

local ui = ns.ui
local Class = ns.util.Class
local Frame = ui.Frame

local _G, tinsert = _G, table.insert
local UISpecialFrames = ns.g.UISpecialFrames

-- dialog with title bar and close button, closable with escape
local Dialog = Class(Frame, function(o)
  local frame = o.frame
  frame:SetFrameStrata("DIALOG")
  frame:SetClampedToScreen(true)

  -- make it closable with Escape key
  _G[frame:GetName()] = frame -- put it in the global namespace
  tinsert(UISpecialFrames, frame:GetName()) -- make it a special frame

  -- set the title
  frame:SetTitle(o.title or frame:GetName())
  o.title = nil
end)
ui.Dialog = Dialog

function Dialog:makeTitlebarDraggable()
  self.frame.TitleContainer:SetScript("OnMouseDown", function()
    self.frame:StartMoving()
  end)
  self.frame.TitleContainer:SetScript("OnMouseUp", function()
    self.frame:StopMovingOrSizing()
  end)
  return self
end
