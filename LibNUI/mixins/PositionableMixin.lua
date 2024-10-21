local _, ns = ...
local ui = ns.ui

-- luacheck: globals unpack
local unpack = unpack

local Mixin = {}
ns.PositionableMixin = Mixin

function Mixin:Position()
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
  end
end

function Mixin:All() self._element:SetAllPoints() end
function Mixin:Center(...) self._element:SetPoint(ui.edge.Center, ...) end
function Mixin:Top(...) self._element:SetPoint(ui.edge.Top, ...) end
function Mixin:TopLeft(...) self._element:SetPoint(ui.edge.TopLeft, ...) end
function Mixin:TopRight(...) self._element:SetPoint(ui.edge.TopRight, ...) end
function Mixin:Bottom(...) self._element:SetPoint(ui.edge.Bottom, ...) end
function Mixin:BottomLeft(...) self._element:SetPoint(ui.edge.BottomLeft, ...) end
function Mixin:BottomRight(...) self._element:SetPoint(ui.edge.BottomRight, ...) end
function Mixin:Left(...) self._element:SetPoint(ui.edge.Left, ...) end
function Mixin:Right(...) self._element:SetPoint(ui.edge.Right, ...) end
function Mixin:Size(x, y) self._element:SetSize(x, y) end
function Mixin:Width(w)
  if w ~= nil then self._element:SetWidth(w) end
  return self._element:GetWidth()
end
function Mixin:Height(h)
  if h ~= nil then self._element:SetHeight(h) end
  return self._element:GetHeight()
end
function Mixin:Show() self._element:Show() end
function Mixin:Hide() self._element:Hide() end
function Mixin:Toggle()
  self._element:SetShown(not self._element:IsVisible())
end
function Mixin:SetShown(b) self._element:SetShown(b) end
