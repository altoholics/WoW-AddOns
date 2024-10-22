local _, ns = ...
local ui = ns.ui
local Class = ns.lua.Class
local Button = ui.Button

-- https://wowpedia.fandom.com/wiki/SecureActionButtonTemplate
local SecureButton = Class(Button, function(self)
  if self.actions then
    for _,action in pairs(self.actions) do
      if action.type then self:Attribute("type", action.type) end
      if action.spell then self:Attribute("spell", action.spell) end
      if action.target then self:Attribute("unit", action.target) end
      if action.toy then self:Attribute("toy", action.toy) end
    end
  end
end, {
  template = "SecureActionButtonTemplate",
})
ui.SecureButton = SecureButton
