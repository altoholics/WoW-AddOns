local _, ns = ...

local ui, Class = ns.ui, ns.lua.Class
local Frame, StatusBar, Label, Texture = ui.Frame, ui.StatusBar, ui.Label, ui.Texture
local TopRight = ui.edge.TopRight

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
  self.label = Label:new{
    parent = self,
    font = "SystemFont_Tiny2",
    color = {1, 1, 1, 1},
    position = {
      Center = {},
      Height = self:Height() - 2,
    },
  }
  self.label._widget:SetShadowColor(0, 0, 0, 0.8)
  self.label._widget:SetShadowOffset(1, -1)
end, {
  backdrop = {0, 0, 0, 0.3},
  level = 1,
  position = {
    Height = 7,
  },
  fill = {
    color = {1, 1, 1},
    blend = "ADD",
  },
})

function RepBar:update()
  local info = ns.wow.Factions.GetMajorFactionRenownInfo(self.factionId)
  local p = info.renownReputationEarned / info.renownLevelThreshold
  self.fill:Width(p * self:Width())
  self.label:Text(ns.lua.floor(p * 100) .. "%")
end

local RepBarContainer = Class(Frame, function(self)
  self.dornogal = RepBar:new{
    factionId = DornogalID,
    parent = self,
    position = {
      TopLeft = {},
    },
    fill = {
      gradient = {"HORIZONTAL", DornogalStart, DornogalEnd},
    },
  }
  self.ringingDeeps = RepBar:new{
    factionId = RingingDeepsID,
    parent = self,
    position = {
      TopLeft = {self.dornogal, TopRight},
    },
    fill = {
      gradient = {"HORIZONTAL", RingingDeepsStart, RingingDeepsEnd},
    },
  }
  self.hallowFall = RepBar:new{
    factionId = HallowfallID,
    parent = self,
    position = {
      TopLeft = {self.ringingDeeps, TopRight},
    },
    fill = {
      gradient = {"HORIZONTAL", HallowfallStart, HallowfallEnd},
    },
  }
  self.severedThreads = RepBar:new{
    factionId = SeveredThreadsID,
    parent = self,
    position = {
      TopLeft = {self.hallowFall, TopRight},
    },
    fill = {
      gradient = {"HORIZONTAL", SeveredThreadsStart, SeveredThreadsEnd},
    },
  }

  -- darken top edge of bar
  self.edge = Texture:new{
    parent = self,
    layer = ui.edge.Overlay,
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.5)},
    position = {
      TopLeft = {},
      BottomRight = {self, TopRight, 0, -3},
    },
  }

  -- fade into ui above
  self.fade = Texture:new{
    parent = self,
    layer = ui.layer.Background,
    color = {1, 1, 1},
    blendMode = "BLEND",
    gradient = {"VERTICAL", rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0)},
    position = {
      TopLeft = {0, 3},
      BottomRight = {self, TopRight},
    },
  }
end, {
  parent = ns.wowui.UIParent,
  strata = "BACKGROUND",
  level = 2,
  position = {
    Height = 7,
    BottomLeft = {},
    BottomRight = {}
  },
  backdrop = {0, 0, 0, 0.3},
  events = {"PLAYER_ENTERING_WORLD"},
})
ns.RepBarContainer = RepBarContainer

function RepBarContainer:reposition()
  local quarterWide = self:Width() / 4
  self.dornogal:Width(quarterWide)
  self.ringingDeeps:Width(quarterWide)
  self.hallowFall:Width(quarterWide)
  self.severedThreads:Width(quarterWide)
end

function RepBarContainer:PLAYER_ENTERING_WORLD(login, reload)
  if (login or reload) then
    self:reposition()
    self.dornogal:update()
    self.ringingDeeps:update()
    self.hallowFall:update()
    self.severedThreads:update()
  end
end
