local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Button = ui.Button

-- https://wowpedia.fandom.com/wiki/SecureActionButtonTemplate
local SecureButton = Class(Button, function(self)
  if self.actions then
    for _,action in pairs(self.actions) do
      if action.type then self.frame:SetAttribute("type", action.type) end
      if action.spell then self.frame:SetAttribute("spell", action.spell) end
      if action.target then self.frame:SetAttribute("unit", action.target) end
      if action.toy then self.frame:SetAttribute("toy", action.toy) end
    end
  end
end, {
  template = "SecureActionButtonTemplate",
})
ui.SecureButton = SecureButton
