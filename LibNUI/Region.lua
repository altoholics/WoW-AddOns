local _, ns = ...
local ui = ns.ui

local Class, Drop, unpack = ns.lua.Class, ns.lua.Drop, ns.lua.unpack

local Region = Class(nil, function(self)
  self._widget = self:CreateWidget()
  local position, alpha = Drop(self, "position", "alpha")
  self:Position(position)
  if alpha then self:Alpha(alpha) end
end)
ui.Region = Region

function Region:Position(position)
  if position then
    for k,v in pairs(position) do
      if self[k] then
        if type(v) == "table" then
          self[k](self, unpack(v))
        else
          self[k](self, v)
        end
      end
    end
  end
end

function Region:SetPoint(point, target, edge, x, y)
  if type(target) == "table" and target._widget then target = target._widget end
  self._widget:SetPoint(point, target, edge, x, y)
end

function Region:All() self._widget:SetAllPoints() end
function Region:Center(...) self:SetPoint(ui.edge.Center, ...) end
function Region:Top(...) self:SetPoint(ui.edge.Top, ...) end
function Region:TopLeft(...) self:SetPoint(ui.edge.TopLeft, ...) end
function Region:TopRight(...) self:SetPoint(ui.edge.TopRight, ...) end
function Region:Bottom(...) self:SetPoint(ui.edge.Bottom, ...) end
function Region:BottomLeft(...) self:SetPoint(ui.edge.BottomLeft, ...) end
function Region:BottomRight(...) self:SetPoint(ui.edge.BottomRight, ...) end
function Region:Left(...) self:SetPoint(ui.edge.Left, ...) end
function Region:Right(...) self:SetPoint(ui.edge.Right, ...) end

function Region:Size(x, y) return x == nil and self._widget:GetSize() or self._widget:SetSize(x, y) end

function Region:Width(w) return w == nil and self._widget:GetWidth() or self._widget:SetWidth(w) end
function Region:Height(h) return h == nil and self._widget:GetHeight() or self._widget:SetHeight(h) end
function Region:Show() self._widget:Show() end
function Region:Hide() self._widget:Hide() end
function Region:Toggle() self._widget:SetShown(not self._widget:IsVisible()) end
function Region:SetShown(b) self._widget:SetShown(b) end

function Region:Alpha(a) return a == nil and self._widget:GetAlpha() or self._widget:SetAlpha(a) end
