local _, ns = ...
local ui = ns.ui

local Class, Frame, CleanFrame, Label = ns.lua.Class, ui.Frame, ui.CleanFrame, ui.Label
local TopLeft, TopRight = ui.edge.TopLeft, ui.edge.TopRight
local Left, Right, Center = ui.edge.Left, ui.edge.Right, ui.edge.Center

local TitleFrame = Class(CleanFrame, function(o)
  -- title bar
  o.titlebar = Frame:new{
    parent = o,
    name = "$parentTitle",
    position = {
      TopLeft = {o._widget, TopLeft},
      TopRight = {o._widget, TopRight},
      Height = 30,
    },
    dragTarget = o._widget,
    background = {0, 0, 0, 0.5},
  }
  o.titlebar.title = Label:new{
    parent = o.titlebar,
    name = "$parentText",
    layer = "OVERLAY",
    font = ui.fonts.SystemFont_Med2,
    position = {
      Left = {o.titlebar._widget, 28, 0},
    },
    text = o.title,
    justifyH = Left,
    justifyV = "MIDDLE",
  }

  -- icon
  o.titlebar.icon = Frame:new{
    parent = o.titlebar,
    position = {
      Left = {6, 0},
      Size = {20, 20},
    },
  }
  o.titlebar.icon:withTextureArtwork("icon", {
    name = "$parentIcon",
    path = "Interface/Icons/inv_10_tailoring2_banner_green.blp",
    coords = {0.1, 0.9, 0.1, 0.9},
    position = { All = true },
  })

  -- close button
  o.closeButton = Frame:new{
    type = "Button",
    parent = o.titlebar,
    name = "$parentCloseButton",
    position = {
      Width = 30,
      Height = 30,
      Right = {o.titlebar._widget, Right, 0, 0},
    },
    background = {1, 1, 1, 0},
  }
  o.closeButton._widget:SetScript("OnClick", function() o:Hide() end)
  o.closeButton._widget:SetScript("OnEnter", function()
    o.closeButton.icon._widget:SetVertexColor(1, 1, 1, 1)
    o.closeButton.background._widget:SetColorTexture(1, 0, 0, 0.2)
  end)
  o.closeButton._widget:SetScript("OnLeave", function()
    o.closeButton.icon._widget:SetVertexColor(0.7, 0.7, 0.7, 1)
    o.closeButton.background._widget:SetColorTexture(1, 1, 1, 0)
  end)
  o.closeButton:withTextureArtwork("icon", {
    name = "$parentIcon",
    position = {
      Center = {o.closeButton._widget, Center},
    },
    path = "Interface/AddOns/Warbandeer/icons/close.blp",
  })
  o.closeButton.icon._widget:SetSize(10, 10)
  o.closeButton.icon._widget:SetVertexColor(0.7, 0.7, 0.7, 1)
end, {
  drag = true,
})
ui.TitleFrame = TitleFrame

function TitleFrame:Title(text)
  self.titlebar.title:Text(text)
end
