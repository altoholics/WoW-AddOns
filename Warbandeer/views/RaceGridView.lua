local _, ns = ...
local ui = ns.ui
local Class, Frame, TableFrame = ns.ui.Class, ui.Frame, ui.TableFrame
local TopLeft, TopRight = ns.ui.edge.TopLeft, ns.ui.edge.TopRight
local BottomLeft, BottomRight = ns.ui.edge.BottomLeft, ns.ui.edge.BottomRight

local ALLIANCE_RACES, CLASS_NAMES, CLASSES = ns.ALLIANCE_RACES, ns.CLASS_NAMES, ns.CLASSES

local rgba = ns.g.CreateColor

local CELL_WIDTH = 85
local CELL_HEIGHT = 24
local HeaderHeight = CELL_HEIGHT * 1.5

-- todo: make button
local FactionIcon = Class(Frame, function(o)
  o.allianceIcon = "Interface/Icons/ui_allianceicon"
  o.hordeIcon = "Interface/Icons/ui_hordeicon"
  o.isAlliance = true
  o:withTextureArtwork("factionIcon", {
    positionAll = true,
    coords = {0.1, 0.9, 0.1, 0.9},
    texturePath = o.allianceIcon,
  })
end)

function FactionIcon:swap()
  self.factionIcon:setTexture(self.isAlliance and self.allianceIcon or self.hordeIcon)
  self.isAlliance = not self.isAlliance
end

local AllianceView = Class(TableFrame, function(o)
  -- color the backgrounds of the rows by class color
  for i=1,ns.g.NUM_CLASSES do
    o:row(i):backdropColor(CLASSES[i].color.r, CLASSES[i].color.g, CLASSES[i].color.b, 0.2)
  end

  local toons = ns.api.GetAllCharacters()
  for _,data in pairs(toons) do
    local col, isAlliance = ns.NormalizeRaceId(data.raceId)
    if isAlliance then
      local row = data.classId
      local w = o.cols[1].frame:GetWidth()
      local cell = Frame:new{
        parent = o.frame,
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

end, {
  CELL_WIDTH = CELL_WIDTH,
  CELL_HEIGHT = CELL_HEIGHT,
  headerHeight = HeaderHeight,
  colNames = ALLIANCE_RACES,
  rowNames = CLASS_NAMES,
  position = {
    topLeft = {},
    bottomRight = {},
  },
  headerFont = "GameFontHighlightSmall",
})

local RaceGridView = Class(Frame, function(o)
  o.allianceView = AllianceView:new{
    parent = o.frame,
  }

  o.factionIcon = FactionIcon:new{
    parent = o.frame,
    position = {
      topLeft = {53, -4},
      width = 32,
      height = 32,
    },
  }

  local status = Frame:new{
    parent = o.frame,
    position = {
      topLeft = {o.frame, BottomLeft, 0, 10},
      bottomRight = {},
    },
  }
  -- status:addBackdrop({color = {0, 0, 0, 0.2}})
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
end)
ns.RaceGridView = RaceGridView
