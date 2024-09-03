local ADDON_NAME, ns = ...

local ui = ns.g.ui
local Frame, StatusBar = ui.Frame, ui.StatusBar
local TopLeft, TopRight, BottomLeft, BottomRight = ui.edge.TopLeft, ui.edge.TopRight, ui.edge.BottomLeft, ui.edge.BottomRight

local rgb = ns.CreateColor

-- Major Factions IDs:
local HallowfallID = 2570
local DornogalID = 2590
local RingingDeepsID = 2594
local SeveredThreadsID = 2600

local WeaverID = 2601
local GeneralID = 2605
local VizierID = 2607
local BrannID = 2640

local DornogalStart = rgb(55, 138, 191)
local DornogalEnd = rgb(124, 135, 190)
local RingingDeepsStart = rgb(239, 111, 53)
local RingingDeepsEnd = rgb(250, 111, 66)
local HallowfallStart = rgb(247, 190, 143)
local HallowfallEnd = rgb(253, 199, 134)
local SeveredThreadsStart = rgb(169, 71, 59)
local SeveredThreadsEnd = rgb(244, 124, 102)

local Container = Frame:new{
  parent = ns.g.UIParent,
  position = {
    height = 7,
    bottomLeft = {},
    bottomRight = {}
  },
  events = {"PLAYER_ENTERING_WORLD"},
  backdrop = {0, 0, 0, 0.3},
  onLoad = function(self)
    self:hide()
    self.dornogal = StatusBar:new{
      parent = self.frame,
      position = {topLeft = {}, bottomRight = {}},
      fill = {
        color = {1, 1, 1},
        blend = "ADD",
        gradient = {"HORIZONTAL", DornogalStart, DornogalEnd},
      },
    }
    self.ringingDeeps = StatusBar:new{
      parent = self.frame,
      position = {topLeft = {}, bottomRight = {}},
      fill = {
        color = {1, 1, 1},
        blend = "ADD",
        gradient = {"HORIZONTAL", RingingDeepsStart, RingingDeepsEnd},
      },
    }
    self.hallowFall = StatusBar:new{
      parent = self.frame,
      position = {topLeft = {}, bottomRight = {}},
      fill = {
        color = {1, 1, 1},
        blend = "ADD",
        gradient = {"HORIZONTAL", HallowfallStart, HallowfallEnd},
      },
    }
    self.severedThreads = StatusBar:new{
      parent = self.frame,
      position = {topLeft = {}, bottomRight = {}},
      fill = {
        color = {1, 1, 1},
        blend = "ADD",
        gradient = {"HORIZONTAL", SeveredThreadsStart, SeveredThreadsEnd},
      },
    }
  end
}

function Container:reposition()
  local quarterWide = self.frame:GetWidth() / 4
  self.dornogal:topLeft()
  self.dornogal:bottomRight(self.frame, BottomLeft, quarterWide - 1, 0)
  self.ringingDeeps:topLeft(quarterWide + 1, 0)
  self.ringingDeeps:bottomRight(self.frame, BottomLeft, quarterWide * 2 - 1, 0)
  self.hallowFall:topLeft(quarterWide * 2 + 1, 0)
  self.hallowFall:bottomRight(self.frame, BottomLeft, quarterWide * 3 - 1, 0)
  self.severedThreads:topLeft(quarterWide * 3 + 1, 0)
  self.severedThreads:bottomRight()
end

local function factionFill(factionID)
  local info = ns.g.GetMajorFactionRenownInfo(factionID)
  return info.renownReputationEarned / info.renownLevelThreshold
end

-- name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(2)
function Container:PLAYER_ENTERING_WORLD(login, reload)
  if (login or reload) and ns.g.UnitLevel("player") == ns.g.maxLevel then
    self:show()
    self:reposition()
    self.dornogal.fill.texture:SetWidth(factionFill(DornogalID) * self.dornogal.frame:GetWidth())
    self.ringingDeeps.fill.texture:SetWidth(factionFill(RingingDeepsID) * self.ringingDeeps.frame:GetWidth())
    self.hallowFall.fill.texture:SetWidth(factionFill(HallowfallID) * self.hallowFall.frame:GetWidth())
    self.severedThreads.fill.texture:SetWidth(factionFill(SeveredThreadsID) * self.severedThreads.frame:GetWidth())
  end
end
