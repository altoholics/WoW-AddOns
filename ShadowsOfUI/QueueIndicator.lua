local _, ns = ...
local ui = ns.ui
local Class, UIParent = ns.lua.Class, ns.wowui.UIParent
local Frame, Label = ui.Frame, ui.Label
local GetLFGQueueStats = GetLFGQueueStats -- luacheck: globals GetLFGQueueStats

local QueueIndicator = Class(Frame, function(self)
  self.timer = Label:new{
    parent = self,
    justifyH = "LEFT",
    position = { All = true },
  }
end, {
  parent = UIParent,
  name = "ShadowUIQueueIndicator",
  strata = "BACKGROUND",
  position = {
    Width = 80,
    Height = 16,
    BottomLeft = {UIParent, ui.edge.BottomRight, -300, 34},
    Hide = true,
  },
  events = {"LFG_QUEUE_STATUS_UPDATE"},
})
ns.QueueIndicator = QueueIndicator

-- https://wowpedia.fandom.com/wiki/API_C_LFGInfo.GetAllEntriesForCategory
local function queueStats(cat)
  local hasData, leaderNeeds, tankNeeds, healerNeeds, dpsNeeds, totalTanks, totalHealers, totalDPS, instanceType,
  instanceSubType, instanceName, averageWait, tankWait, healerWait, dpsWait, myWait, queuedTime, activeID =
  GetLFGQueueStats(cat)
  return hasData and {
    hasData = hasData,
    leaderNeeds = leaderNeeds,
    tankNeeds = tankNeeds,
    healerNeeds = healerNeeds,
    dpsNeeds = dpsNeeds,
    totalTanks = totalTanks,
    totalHealers = totalHealers,
    totalDPS = totalDPS,
    instanceType = instanceType,
    instanceSubType = instanceSubType,
    instanceName = instanceName,
    averageWait = averageWait,
    tankWait = tankWait,
    healerWait = healerWait,
    dpsWait = dpsWait,
    myWait = myWait,
    queuedTime = queuedTime,
    activeID = activeID,
  }
end

-- luacheck: globals GetTime SecondsToClock
local function parseTimer(data)
  local elapsed = GetTime() - data.queuedTime
  if elapsed > data.myWait then
    return SecondsToClock(elapsed - data.myWait)
  else
    return SecondsToClock(data.myWait - elapsed)
  end
end

function QueueIndicator:LFG_QUEUE_STATUS_UPDATE()
  local lfdInfo, lfrInfo, rfInfo, scenario, custom = queueStats(1), queueStats(2), queueStats(3), queueStats(5), queueStats(6)
  -- 4 arenas
  -- 7 arena skirmishes
  -- 8 battlegrounds
  -- 121 delves
  if lfdInfo then
    self.timer:Text(parseTimer(lfdInfo))
  elseif lfrInfo then
    print("lfr queue update")
    self.timer:Text(parseTimer(lfrInfo))
  elseif rfInfo then
    print("raid finder queue update")
    self.timer:Text(parseTimer(rfInfo))
  elseif scenario then
    print("scenario group finder queue update")
    self.timer:Text(parseTimer(scenario))
  elseif custom then
    print("custom group finder update")
    self.timer:Text(parseTimer(custom))
  end
end
