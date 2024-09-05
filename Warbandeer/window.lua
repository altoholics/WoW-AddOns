local addOnName, ns = ...

-- set up the main addon window

local Frame, PortraitFrame, TableFrame = ns.ui.Frame, ns.ui.PortraitFrame, ns.ui.TableFrame

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

local ALLIANCE_RACES, CLASS_NAMES, CLASSES = ns.ALLIANCE_RACES, ns.CLASS_NAMES, ns.CLASSES

local function CreateMainFrame()
    local pf = PortraitFrame:new{
        name = addOnName,
        portraitPath = "Interface\\Icons\\inv_10_tailoring2_banner_green.blp",
    }
    pf:center()
    pf:size(100 * (#ALLIANCE_RACES + 1) + 20, 400)

    -- add the contents
    local t = TableFrame:new{
        parent = pf.frame,
        CELL_WIDTH = 100,
        CELL_HEIGHT = 24,
        colNames = ALLIANCE_RACES,
        rowNames = CLASS_NAMES,
    }
    t:topLeft(12, -56)
    t:bottomRight(-58, 8)

    -- color the backgrounds of the rows by class color
    for i=1,ns.g.NUM_CLASSES do
        t:row(i):backdropColor(CLASSES[i].color.r, CLASSES[i].color.g, CLASSES[i].color.b, 0.2)
    end

    for name,data in pairs(ns.api.GetAllCharacters()) do
      local col = ns.NormalizeRaceId(data.raceId)
      local row = data.classId
      local w = t.cols[1].frame:GetWidth()
      local cell = Frame:new{
        parent = t.frame,
        level = 3,
        position = {
          topLeft = {col * w + 3, row * -24 - 5},
          width = w - 6,
          height = 24 - 10,
        },
      }
      local label = cell.frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
      label:SetText(name)
      label:SetPoint("TOPLEFT")
    end

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
