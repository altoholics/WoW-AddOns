local _, ns = ...
-- luacheck: globals SlashCmdList InterfaceOptionsFrame_OpenToCategory GetAverageItemLevel C_ClassColor GetClassInfo
-- luacheck: globals GetNumClasses GetMaxLevelForPlayerExpansion GetProfessions GetProfessionInfo GetRealmName
-- luacheck: globals GetServerTime C_DateAndTime UnitClassBase UnitLevel UnitName UnitRace C_AddOns UnitXP UnitXPMax
-- luacheck: globals GetXPExhaustion GetRestState UnitExists UnitAffectingCombat GetFactionInfoByID C_MajorFactions
-- luacheck: globals C_WeeklyRewards C_Item LoadAddOn

ns.wow = {
  SlashCmdList = SlashCmdList,
  ShowOptionsCategory = InterfaceOptionsFrame_OpenToCategory,

  -- WoW API
  -- Bags / Inventory
  GetAverageItemLevel = GetAverageItemLevel,

  -- Class
  GetClassColor = C_ClassColor.GetClassColor,
  GetClassInfo = GetClassInfo, -- https://wowpedia.fandom.com/wiki/API_UnitClass
  NUM_CLASSES = GetNumClasses(),

  -- Expansions
  maxLevel = GetMaxLevelForPlayerExpansion(),

  -- Items
  GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo,

  -- Professions
  GetProfessions = GetProfessions,
  GetProfessionInfo = GetProfessionInfo,

  -- Realms
  RealmName = GetRealmName(),

  -- System / Date & Time
  GetServerTime = GetServerTime,
  GetSecondsUntilWeeklyReset = C_DateAndTime.GetSecondsUntilWeeklyReset,
  -- GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() - 604800
  -- if last recorded time <= GetServerTime(), do weekly reset

  -- Weekly Rewards
  GetActivities = C_WeeklyRewards.GetActivities,
  GetExampleRewardItemHyperlinks = C_WeeklyRewards.GetExampleRewardItemHyperlinks,

  -- Units
  UnitClassBase = UnitClassBase,
  UnitLevel = UnitLevel,
  UnitName = UnitName,
  UnitRace = UnitRace,

  LoadAddOn = C_AddOns.LoadAddOn,
  IsAddOnLoaded = C_AddOns.IsAddOnLoaded,
  UnitXP = UnitXP,
  UnitXPMax = UnitXPMax,
  GetXPExhaustion = GetXPExhaustion,
  GetRestState = GetRestState,
  UnitExists = UnitExists,
  UnitAffectingCombat = UnitAffectingCombat,
  GetFactionInfoByID = GetFactionInfoByID,
  GetMajorFactionRenownInfo = C_MajorFactions.GetMajorFactionRenownInfo,
}

ns.wow.Player = {}
function ns.wow.Player.name() return ns.wow.UnitName("player") end
function ns.wow.Player.level() return ns.wow.UnitLevel("player") end
function ns.wow.Player.isMaxLevel() return ns.wow.UnitLevel("player") == ns.wow.maxLevel end
function ns.wow.Player.xp() return ns.wow.UnitXP("player") end
function ns.wow.Player.xpMax() return ns.wow.UnitXPMax("player") end
function ns.wow.Player.getXPPercent() return ns.wow.Player.xp() / ns.wow.Player.xpMax() end
function ns.wow.Player.isRested() return 1 == ns.wow.GetRestState() end
function ns.wow.Player.getXPExhaustion() return ns.wow.GetXPExhaustion() end
function ns.wow.Player.getRestPercent()
  if not ns.wow.Player.isRested() then return 0 end
  local max = ns.wow.Player.xpMax()
  return ns.lua.min(ns.wow.Player.getXPExhaustion(), max) - ns.wow.Player.xp() / max
end

ns.wow.GreatVault = {}
function ns.wow.GreatVault.getRewardOptions()
  local rewards = {}
  local counts = {}
  local best = 0
  local bestN = 0
  -- https://wowpedia.fandom.com/wiki/API_C_WeeklyRewards.GetActivities
  local activities = ns.wow.GetActivities()
  for _,activity in ipairs(activities) do
    if activity.progress >= activity.threshold then
      local link = ns.wow.GetExampleRewardItemHyperlinks(activity.id)
      if link then
        local ilvl = ns.wow.GetDetailedItemLevelInfo(link)
        if ilvl then
          if not counts[ilvl] then
            counts[ilvl] = 1
          else
            counts[ilvl] = counts[ilvl] + 1
          end
          if ilvl > best then
            best = ilvl
            bestN = 1
          elseif ilvl == best then
            bestN = bestN + 1
          end
        end
      end
    end
  end
  return rewards, counts, best, bestN
end
