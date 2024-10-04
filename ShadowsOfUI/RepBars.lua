local _, ns = ...

local ui, Class = ns.ui, ns.lua.Class
local Frame, StatusBar = ui.Frame, ui.StatusBar
local TopLeft, TopRight = ui.edge.TopLeft, ui.edge.TopRight
local BottomRight = ui.edge.BottomRight

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

local RepBar = Class(StatusBar, function(self)
end, {
  level = 1,
  position = {
    height = 7,
  },
  fill = {
    color = {1, 1, 1},
    blend = "ADD",
  },
})

function RepBar:update()
  local info = ns.wow.GetMajorFactionRenownInfo(self.factionID)
  local p = info.renownReputationEarned / info.renownLevelThreshold
  self.fill.texture:SetWidth(p * self:width())
end

local RepBarContainer = Class(Frame, function(self)
  self.dornogal = RepBar:new{
    factionId = DornogalID,
    parent = self.frame,
    position = {
      topLeft = {},
    },
    fill = {
      gradient = {"HORIZONTAL", DornogalStart, DornogalEnd},
    },
  }
  self.ringingDeeps = RepBar:new{
    factionId = RingingDeepsID,
    parent = self.frame,
    position = {
      topLeft = {self.dornogal.frame, TopRight},
    },
    fill = {
      gradient = {"HORIZONTAL", RingingDeepsStart, RingingDeepsEnd},
    },
  }
  self.hallowFall = RepBar:new{
    factionId = HallowfallID,
    parent = self.frame,
    position = {
      topLeft = {self.ringingDeeps.frame, TopRight},
    },
    fill = {
      gradient = {"HORIZONTAL", HallowfallStart, HallowfallEnd},
    },
  }
  self.severedThreads = RepBar:new{
    factionId = SeveredThreadsID,
    parent = self.frame,
    position = {
      topLeft = {self.hallowFall.frame, TopRight},
    },
    fill = {
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
end, {
  parent = ns.wowui.UIParent,
  strata = "BACKGROUND",
  level = 2,
  position = {
    height = 7,
    bottomLeft = {},
    bottomRight = {}
  },
  backdrop = {0, 0, 0, 0.3},
  events = {"PLAYER_ENTERING_WORLD"},
})
ns.RepBarContainer = RepBarContainer

function RepBarContainer:reposition()
  local quarterWide = self.frame:GetWidth() / 4
  self.dornogal:width(quarterWide)
  self.ringingDeeps:width(quarterWide)
  self.hallowFall:width(quarterWide)
  self.severedThreads:width(quarterWide)
end

function RepBarContainer:PLAYER_ENTERING_WORLD(login, reload)
  if (login or reload) then
    self:reposition()
    self.dornogal.update()
    self.ringingDeeps.update()
    self.hallowFall.update()
    self.severedThreads.update()
  end
end
