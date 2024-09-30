local _, ns = ...
local ui = ns.ui

local Class, Frame, CleanFrame = ns.lua.Class, ui.Frame, ui.CleanFrame
local TopLeft, TopRight = ui.edge.TopLeft, ui.edge.TopRight
local Left, Right, Center = ui.edge.Left, ui.edge.Right, ui.edge.Center

local TitleFrame = Class(CleanFrame, function(o)
  -- title bar
  o.titlebar = Frame:new{
    parent = o,
    name = "$parentTitle",
    position = {
      topLeft = {o.frame, TopLeft},
      topRight = {o.frame, TopRight},
      height = 30,
    },
    dragTarget = o.frame,
    background = {0, 0, 0, 0.5},
  }
  o.titlebar:withLabel("title", {
    name = "$parentText",
    layer = "OVERLAY",
    font = ui.fonts.SystemFont_Med2,
    position = {
      left = {o.titlebar.frame, 28, 0},
    },
    text = o.title,
    justifyH = Left,
    justifyV = "MIDDLE",
  })

  -- icon
  o.titlebar.icon = Frame:new{
    parent = o.titlebar,
    position = {
      left = {6, 0},
      size = {20, 20},
    },
  }
  o.titlebar.icon:withTextureArtwork({
    name = "icon",
    textureName = "$parentIcon",
    texturePath = "Interface/Icons/inv_10_tailoring2_banner_green.blp",
    coords = {0.1, 0.9, 0.1, 0.9},
    positionAll = true,
  })

  -- close button
  o.closeButton = Frame:new{
    type = "Button",
    parent = o.titlebar,
    name = "$parentCloseButton",
    position = {
      width = 30,
      height = 30,
      right = {o.titlebar.frame, Right, 0, 0},
    },
    background = {1, 1, 1, 0},
  }
  o.closeButton.frame:SetScript("OnClick", function() o:hide() end)
  o.closeButton.frame:SetScript("OnEnter", function()
    o.closeButton.icon.texture:SetVertexColor(1, 1, 1, 1)
    o.closeButton.background.texture:SetColorTexture(1, 0, 0, 0.2)
  end)
  o.closeButton.frame:SetScript("OnLeave", function()
    o.closeButton.icon.texture:SetVertexColor(0.7, 0.7, 0.7, 1)
    o.closeButton.background.texture:SetColorTexture(1, 1, 1, 0)
  end)
  o.closeButton:withTextureArtwork("icon", {
    textureName = "$parentIcon",
    clamp = {
      {Center, o.closeButton.frame, Center},
    },
    texturePath = "Interface/AddOns/Warbandeer/icons/close.blp",
  })
  o.closeButton.icon.texture:SetSize(10, 10)
  o.closeButton.icon.texture:SetVertexColor(0.7, 0.7, 0.7, 1)

end, {
  drag = true,
})
ui.TitleFrame = TitleFrame

function TitleFrame:Title(text)
  self.titlebar.title:Text(text)
end
