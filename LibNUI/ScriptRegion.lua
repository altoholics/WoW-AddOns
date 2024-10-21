local _, ns = ...
local ui = ns.ui

local Class, unpack = ns.lua.Class, ns.lua.unpack

local ScriptRegion = Class(nil, function(self)
  self._widget = self:CreateWidget()
  self:Position()
end)
ui.ScriptRegion = ScriptRegion

function ScriptRegion:Position()
  if self.position then
    for k,v in pairs(self.position) do
      if self[k] then
        if type(v) == "table" then
          self[k](self, unpack(v))
        else
          self[k](self, v)
        end
      end
    end
    self.position = nil
  end
end

function ScriptRegion:All() self._widget:SetAllPoints() end
function ScriptRegion:Center(...) self._widget:SetPoint(ui.edge.Center, ...) end
function ScriptRegion:Top(...) self._widget:SetPoint(ui.edge.Top, ...) end
function ScriptRegion:TopLeft(...) self._widget:SetPoint(ui.edge.TopLeft, ...) end
function ScriptRegion:TopRight(...) self._widget:SetPoint(ui.edge.TopRight, ...) end
function ScriptRegion:Bottom(...) self._widget:SetPoint(ui.edge.Bottom, ...) end
function ScriptRegion:BottomLeft(...) self._widget:SetPoint(ui.edge.BottomLeft, ...) end
function ScriptRegion:BottomRight(...) self._widget:SetPoint(ui.edge.BottomRight, ...) end
function ScriptRegion:Left(...) self._widget:SetPoint(ui.edge.Left, ...) end
function ScriptRegion:Right(...) self._widget:SetPoint(ui.edge.Right, ...) end
function ScriptRegion:Size(x, y) self._widget:SetSize(x, y) end
function ScriptRegion:Width(w)
  if w ~= nil then self._widget:SetWidth(w) end
  return self._widget:GetWidth()
end
function ScriptRegion:Height(h)
  if h ~= nil then self._widget:SetHeight(h) end
  return self._widget:GetHeight()
end
function ScriptRegion:Show() self._widget:Show() end
function ScriptRegion:Hide() self._widget:Hide() end
function ScriptRegion:Toggle() self._widget:SetShown(not self._widget:IsVisible()) end
function ScriptRegion:SetShown(b) self._widget:SetShown(b) end
