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
