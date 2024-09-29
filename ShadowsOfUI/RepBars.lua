local _, ns = ...

local ui = ns.ui
local Frame, StatusBar = ui.Frame, ui.StatusBar
local TopLeft, TopRight = ui.edge.TopLeft, ui.edge.TopRight
local BottomLeft, BottomRight = ui.edge.BottomLeft, ui.edge.BottomRight

local rgba = ns.wowui.rgba

-- Major Factions IDs:
local HallowfallID = 2570
local DornogalID = 2590
local RingingDeepsID = 2594
local SeveredThreadsID = 2600

-- local WeaverID = 2601
-- local GeneralID = 2605
-- local VizierID = 2607
-- local BrannID = 2640

local DornogalStart = rgba(55, 138, 191)
local DornogalEnd = rgba(124, 135, 190)
local RingingDeepsStart = rgba(239, 111, 53)
local RingingDeepsEnd = rgba(247, 217, 122)
local HallowfallStart = rgba(247, 190, 143)
local HallowfallEnd = rgba(251, 216, 178)
local SeveredThreadsStart = rgba(169, 71, 59)
local SeveredThreadsEnd = rgba(244, 124, 102)

local Container = Frame:new{
  parent = ns.wowui.UIParent,
  level = 2,
  position = {
    height = 7,
    bottomLeft = {},
    bottomRight = {}
  },
  events = {"PLAYER_ENTERING_WORLD"},
  backdrop = {0, 0, 0, 0.3},
  onLoad = function(self)
    self:hide()
    self.frame:SetFrameStrata("BACKGROUND")
    self.dornogal = StatusBar:new{
      parent = self.frame,
      level = 1,
      position = {topLeft = {}, bottomRight = {}},
      fill = {
        color = {1, 1, 1},
        blend = "ADD",
        gradient = {"HORIZONTAL", DornogalStart, DornogalEnd},
      },
    }
    self.ringingDeeps = StatusBar:new{
      parent = self.frame,
      level = 1,
      position = {topLeft = {}, bottomRight = {}},
      fill = {
        color = {1, 1, 1},
        blend = "ADD",
        gradient = {"HORIZONTAL", RingingDeepsStart, RingingDeepsEnd},
      },
    }
    self.hallowFall = StatusBar:new{
      parent = self.frame,
      level = 1,
      position = {topLeft = {}, bottomRight = {}},
      fill = {
        color = {1, 1, 1},
        blend = "ADD",
        gradient = {"HORIZONTAL", HallowfallStart, HallowfallEnd},
      },
    }
    self.severedThreads = StatusBar:new{
      parent = self.frame,
      level = 1,
      position = {topLeft = {}, bottomRight = {}},
      fill = {
        color = {1, 1, 1},
        blend = "ADD",
        gradient = {"HORIZONTAL", SeveredThreadsStart, SeveredThreadsEnd},
      },
    }

    -- darken top edge of bar
    self:withTextureOverlay("edge", {
      color = {1, 1, 1},
      blendMode = "BLEND",
      gradient = {"VERTICAL", rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.5)},
      clamp = {
        {TopLeft},
        {BottomRight, self.frame, TopRight, 0, -3}
      },
    })

    -- fade into ui above
    self:withTextureBackground("fade", {
      color = {1, 1, 1},
      blendMode = "BLEND",
      gradient = {"VERTICAL", rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0)},
      clamp = {
        {TopLeft, 0, 3},
        {BottomRight, self.frame, TopRight},
      },
    })
  end
}

function Container:reposition()
  local quarterWide = self.frame:GetWidth() / 4
  self.dornogal:topLeft()
  self.dornogal:bottomRight(self.frame, BottomLeft, quarterWide, 0)
  self.ringingDeeps:topLeft(quarterWide, 0)
  self.ringingDeeps:bottomRight(self.frame, BottomLeft, quarterWide * 2, 0)
  self.hallowFall:topLeft(quarterWide * 2, 0)
  self.hallowFall:bottomRight(self.frame, BottomLeft, quarterWide * 3, 0)
  self.severedThreads:topLeft(quarterWide * 3, 0)
  self.severedThreads:bottomRight()
end

local function factionFill(factionID)
  local info = ns.wow.GetMajorFactionRenownInfo(factionID)
  return info.renownReputationEarned / info.renownLevelThreshold
end

-- name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep,
-- isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(2)
function Container:PLAYER_ENTERING_WORLD(login, reload)
  if (login or reload) and ns.wow.UnitLevel("player") == ns.wow.maxLevel then
    self:show()
    self:reposition()
    self.dornogal.fill.texture:SetWidth(factionFill(DornogalID) * self.dornogal.frame:GetWidth())
    self.ringingDeeps.fill.texture:SetWidth(factionFill(RingingDeepsID) * self.ringingDeeps.frame:GetWidth())
    self.hallowFall.fill.texture:SetWidth(factionFill(HallowfallID) * self.hallowFall.frame:GetWidth())
    self.severedThreads.fill.texture:SetWidth(factionFill(SeveredThreadsID) * self.severedThreads.frame:GetWidth())
  end
end
