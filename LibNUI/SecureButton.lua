local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Button = ui.Button

-- https://wowpedia.fandom.com/wiki/SecureActionButtonTemplate
local SecureButton = Class(Button, function(self)
  if self.actions then
    for _,action in pairs(self.actions) do
      if action.type then self._widget:SetAttribute("type", action.type) end
      if action.spell then self._widget:SetAttribute("spell", action.spell) end
      if action.target then self._widget:SetAttribute("unit", action.target) end
      if action.toy then self._widget:SetAttribute("toy", action.toy) end
    end
  end
end, {
  template = "SecureActionButtonTemplate",
})
ui.SecureButton = SecureButton
