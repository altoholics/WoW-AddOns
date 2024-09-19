local addOnName, ns = ...

-- set up the main addon window

local PortraitFrame = ns.ui.PortraitFrame
local RaceGridView = ns.views.RaceGridView

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

local ALLIANCE_RACES = ns.ALLIANCE_RACES

local CELL_WIDTH = 85
local CELL_HEIGHT = 24

local function CreateMainFrame()
  local pf = PortraitFrame:new{
    name = addOnName,
    portraitPath = "Interface\\Icons\\inv_10_tailoring2_banner_green.blp",
    position = {
      width = CELL_WIDTH * (#ALLIANCE_RACES + 1) + 16,
      height = CELL_HEIGHT * ns.g.NUM_CLASSES + 65 + 13,
      center = {},
    },
    titleColor = {1, 1, 1, 1},
  }
  local cb = pf.frame.CloseButton
  cb:SetPoint("TOPRIGHT", pf.frame, "TOPRIGHT", -2, -2)
  cb:SetSize(pf.frame.TitleContainer:GetHeight() - 2, pf.frame.TitleContainer:GetHeight() - 2)
  cb:ClearDisabledTexture()
  cb:ClearHighlightTexture()
  cb:ClearPushedTexture()
  cb:ClearNormalTexture()
  pf:withTextureBackground("closeBg", {
    parent = cb,
    positionAll = true,
    color = {1, 1, 1, 0},
  })
  pf:withTextureArtwork("closeIcon", {
    parent = cb,
    texturePath = "Interface/AddOns/Warbandeer/icons/close.blp",
    clamp = {{"CENTER", cb, "CENTER"}},
  })
  pf.closeIcon.texture:SetSize(10, 10)
  pf.closeIcon.texture:SetVertexColor(0.7, 0.7, 0.7, 1)
  cb:SetScript("OnEnter", function()
    pf.closeIcon.texture:SetVertexColor(1, 1, 1, 1)
    pf.closeBg.texture:SetColorTexture(1, 0, 0, 0.2)
  end)
  cb:SetScript("OnLeave", function()
    pf.closeIcon.texture:SetVertexColor(0.7, 0.7, 0.7, 1)
    pf.closeBg.texture:SetColorTexture(1, 1, 1, 0)
  end)

  -- add the contents
  pf.views = {}
  pf.views.raceGrid = RaceGridView:new{
    parent = pf.frame,
    position = {
      topLeft = {8, -20},
      bottomRight = {-58, 8},
    },
  }

  return pf
end

function ns.Open()
  if not ns.MainWindow then
    ns.MainWindow = CreateMainFrame()
  end

  ns.MainWindow:show()
end

function ns:SlashCmd() -- cmd, msg
  self:Open()
end

function ns:CompartmentClick() -- buttonName = (LeftButton | RightButton | MiddleButton)
  self:Open()
end
