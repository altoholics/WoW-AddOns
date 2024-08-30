local _, ns = ...

local ui = ns.g.ui
local Frame = ui.Frame

local ShowUIPanel, HideUIPanel = ns.g.ShowUIPanel, ns.g.HideUIPanel
local BagsBar, MicroMenuContainer, MainMenuBar, MultiBarBottomLeft, MultiBarBottomRight, MultiBarRight, MultiBarLeft, MultiBar5, MultiBar6, MultiBar7 = ns.g.BagsBar, ns.g.MicroMenuContainer, ns.g.MainMenuBar, ns.g.MultiBarBottomLeft, ns.g.MultiBarBottomRight, ns.g.MultiBarRight, ns.g.MultiBarLeft, ns.g.MultiBar5, ns.g.MultiBar6, ns.g.MultiBar7

local BarControl = Frame:new{
  events = {"PLAYER_ENTERING_WORLD"},
}
BarControl:hide()

function BarControl:PLAYER_ENTERING_WORLD(login, reload)
  if login or reload then
    HideUIPanel(BagsBar)
    HideUIPanel(MicroMenuContainer)
    -- for k,v in pairs(MainMenuBar) do
    --   if type(v) == "function" then
    --     print(k)
    --   end
    -- end
    -- for i=1,MainMenuBar.numButtons do
    --   MainMenuBar.actionButtons[i]:Hide()
    -- end
  end
end
