local _, ns = ...
local ui = ns.ui

local Class, Frame = ns.util.Class, ui.Frame
local TopLeft, TopRight, BottomRight = ns.ui.edge.TopLeft, ns.ui.edge.TopRight, ns.ui.edge.BottomRight
local Left, Right, Center = ns.ui.edge.Left, ns.ui.edge.Right, ns.ui.edge.Center

local TitleFrame = Class(Frame, function(o)
  o.border = Frame:new{
    parent = o.frame,
    name = "$parentBorder",
    template = "BackdropTemplate",
    position = {
      topLeft = {o.frame, TopLeft, -3, 3},
      bottomRight = {o.frame, BottomRight, 3, -3},
    },
  }
  o.border.frame:SetBackdrop({
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 16,
    insets = {left = 4, right = 4, top = 4, bottom = 4},
  })
  o.border.frame:SetBackdropBorderColor(0, 0, 0, .5)

  -- title bar
  o.titlebar = Frame:new{
    parent = o.frame,
    name = "$parentTitle",
    position = {
      topLeft = {o.frame, TopLeft},
      topRight = {o.frame, TopRight},
      height = 30,
    },
    dragTarget = o.frame,
    background = {0, 0, 0, 0.5},
  }
  o.titlebar:withTextureArtwork({
    name = "icon",
    textureName = "$parentIcon",
    texturePath = "Interface/Icons/inv_10_tailoring2_banner_green.blp",
    clamp = {
      {Left, o.titlebar.frame, Left, 6, 0},
    },
  })
  o.titlebar.icon.texture:SetSize(20, 20)
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

  -- close button
  o.closeButton = Frame:new{
    type = "Button",
    parent = o.titlebar.frame,
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
  clamped = true,
  strata = "MEDIUM",
  background = {0.11372549019, 0.14117647058, 0.16470588235, 1},
  drag = true,
})
ui.TitleFrame = TitleFrame