local addOnName, ns = ...

-- set up the main addon window

local Frame, PortraitFrame, TableFrame = ns.ui.Frame, ns.ui.PortraitFrame, ns.ui.TableFrame
local TopLeft, TopRight = ns.ui.edge.TopLeft, ns.ui.edge.TopRight
local BottomLeft, BottomRight = ns.ui.edge.BottomLeft, ns.ui.edge.BottomRight

-- https://www.reddit.com/r/wowaddondev/comments/1cc2qgj/creating_a_wow_addon_part_2_creating_a_frame/
-- frame/UI control templates: https://www.wowinterface.com/forums/showthread.php?t=40444

local ALLIANCE_RACES, CLASS_NAMES, CLASSES = ns.ALLIANCE_RACES, ns.CLASS_NAMES, ns.CLASSES

local rgba = ns.g.CreateColor

local CELL_WIDTH = 85
local CELL_HEIGHT = 24
local HeaderHeight = CELL_HEIGHT * 1.5

local function CreateMainFrame()
  local pf = PortraitFrame:new{
    name = addOnName,
    portraitPath = "Interface\\Icons\\inv_10_tailoring2_banner_green.blp",
    position = {
      width = CELL_WIDTH * (#ALLIANCE_RACES + 1) + 16,
      height = CELL_HEIGHT * ns.g.NUM_CLASSES + 65 + 13,
      center = {},
    },
  }
  pf.frame.TitleContainer.TitleText:SetTextColor(1, 1, 1, 1)

  -- add the contents
  local t = TableFrame:new{
    parent = pf.frame,
    CELL_WIDTH = CELL_WIDTH,
    CELL_HEIGHT = CELL_HEIGHT,
    headerHeight = HeaderHeight,
    colNames = ALLIANCE_RACES,
    rowNames = CLASS_NAMES,
    position = {
      topLeft = {8, -20},
      bottomRight = {-58, 8},
    },
    headerFont = "GameFontHighlightSmall",
  }

  t:withTextureArtwork("factionIcon", {})
  -- t.factionIcon.texture:SetTexture("Interface/Icons/ui_hordeicon")
  t.factionIcon.texture:SetTexture("Interface/Icons/ui_allianceicon")
  t.factionIcon.texture:SetPoint(TopLeft, 53, -4)
  t.factionIcon.texture:SetWidth(32)
  t.factionIcon.texture:SetHeight(32)
  t.factionIcon.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)

  -- color the backgrounds of the rows by class color
  for i=1,ns.g.NUM_CLASSES do
    t:row(i):backdropColor(CLASSES[i].color.r, CLASSES[i].color.g, CLASSES[i].color.b, 0.2)
  end

  for i=1,#ALLIANCE_RACES do
    if math.fmod(i, 2) == 0 then
      t:col(i):backdropColor(0, 0, 0, 0.6)
    end
  end

  local toons = ns.api.GetAllCharacters()
  for _,data in pairs(toons) do
    local col, isAlliance = ns.NormalizeRaceId(data.raceId)
    if isAlliance then
      local row = data.classId
      local w = t.cols[1].frame:GetWidth()
      local cell = Frame:new{
        parent = t.frame,
        level = 3,
        position = {
          topLeft = {col * w, (row-1) * -24 - HeaderHeight},
          width = w - 6,
          height = 24 - 10,
        },
      }
      local label = cell.frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
      label:SetText(data.name)
      label:SetPoint("TOPLEFT")
      label:SetWidth(CELL_WIDTH)
      label:SetHeight(CELL_HEIGHT)
      label:SetJustifyH("CENTER")
      label:SetJustifyV("MIDDLE")
      if data.level ~= ns.g.maxLevel then
        label:SetTextColor(0.7, 0.7, 0.7, 1)
      end

      -- https://wowpedia.fandom.com/wiki/UIOBJECT_GameTooltip
      cell.frame:SetScript("OnEnter", function()
        GameTooltip:SetOwner(cell.frame, "ANCHOR_RIGHT")
        GameTooltip:SetText(data.name, 1, 1, 1)
        GameTooltip:AddDoubleLine("Level", data.level, nil, nil, nil, 1, 1, 1)
        GameTooltip:AddDoubleLine("iLvl", data.ilvl, nil, nil, nil, 1, 1, 1)
        if data.prof1 then
          GameTooltip:AddDoubleLine(
            ns.api.professionInfo["sl"..data.prof1.skillID].name,
            data.prof1.skillLevel.."/"..data.prof1.maxSkill,
            nil, nil, nil,
            1, 1, 1
          )
        end
        if data.prof2 then
          GameTooltip:AddDoubleLine(
            ns.api.professionInfo["sl"..data.prof2.skillID].name,
            data.prof2.skillLevel.."/"..data.prof2.maxSkill,
            nil, nil, nil,
            1, 1, 1
          )
        end
        GameTooltip:Show()
      end)
      cell.frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
      end)
    end
  end

  local status = Frame:new{
    parent = pf.frame,
    position = {
      topLeft = {pf.frame, BottomLeft, 4, 18},
      bottomRight = {-4, 5},
    },
  }
  status:addBackdrop({color = {0, 0, 0, 0.2}})
  status:withTextureBackground("fade", {
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0)},
    clamp = {
      {TopLeft, 0, 3},
      {BottomRight, status.frame, TopRight},
    },
  })

  status:withLabel{
    name = "count",
    template = "GameFontHighlightSmall",
    text = "Characters: "..ns.api.GetNumCharacters(),
    position = {TopLeft, 4, -2},
    color = {1, 1, 215/255, 0.8},
  }

  status:withLabel{
    name = "maxLevel",
    template = "GameFontHighlightSmall",
    text = ns.g.maxLevel.."'s: "..ns.api.GetNumMaxLevel(),
    position = {TopLeft, 200, -2},
    color = {1, 1, 215/255, 0.8},
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
