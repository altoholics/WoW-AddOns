local _, ns = ...
-- luacheck: globals UnitXP UnitXPMax GetXPExhaustion GetRestState UnitClassBase GetProfessions GetProfessionInfo
-- luacheck: globals GetAverageItemLevel PlayerHasToy UseToy IsSpellKnown C_MountJournal CastSpell UnitExists
-- luacheck: globals UnitHealth UnitHealthMax InCombatLockdown IsResting UnitPower UnitPowerMax UnitPowerType
-- luacheck: globals GetShapeshiftFormID UnitIsAFK

local Mixin, min, max = ns.lua.Mixin, ns.lua.min, ns.lua.max
local UnitXP, UnitXPMax, GetXPExhaustion, GetRestState = UnitXP, UnitXPMax, GetXPExhaustion, GetRestState
local UnitClassBase, GetAverageItemLevel = UnitClassBase, GetAverageItemLevel
local GetProfessions, GetProfessionInfo = GetProfessions, GetProfessionInfo
local UnitHealth, UnitHealthMax, UnitExists, UnitIsAFK = UnitHealth, UnitHealthMax, UnitExists, UnitIsAFK
local UnitPower, UnitPowerMax, UnitPowerType = UnitPower, UnitPowerMax, UnitPowerType
local InCombatLockdown, IsResting, GetShapeshiftFormID = InCombatLockdown, IsResting, GetShapeshiftFormID
local wow = ns.wow

local Player = {
  Cast = CastSpell,
  GetAverageItemLevel = function() local _, ilvl = GetAverageItemLevel(); return math.floor(ilvl) end,
  GetClassId = function() local _, classId = UnitClassBase("player"); return classId end,
  GetClassName = function(self) return wow.GetClassInfo(self:GetClassId()) end,
  GetHealth = function() return UnitHealth("player") end,
  GetHealthMax = function() return UnitHealthMax("player") end,
  GetHealthPercent = function(self) return math.floor(100 * (self:GetHealth() / self:GetHealthMax())).."%" end,
  GetHealthValues = function(self) return self:GetHealth(), self:GetHealthMax(), self:GetHealthPercent() end,
  GetLevel = function() return wow.UnitLevel("player") end,
  GetMaxXP = function() return UnitXPMax("player") end,
  GetMountIcon = function(id)
    local _, _, icon = C_MountJournal.GetMountInfoByID(id)
    return icon
  end,
  GetName = function() return wow.UnitName("player") end,
  GetPetHealthValues = function() return UnitHealth("pet"), UnitHealthMax("pet") end,
  GetPower = function(self, idx) return UnitPower("player", idx) end,
  GetPowerMax = function(self, idx) return UnitPowerMax("player", idx) end,
  GetPowerPercent = function(self, idx) return math.floor(100 * (self:GetPower(idx) / self:GetPowerMax(idx))).."%" end,
  GetPowerType = function() return UnitPowerType("player") end,
  GetPowerValues = function(self, idx) return self:GetPower(idx), self:GetPowerMax(idx) end,
  -- https://wowpedia.fandom.com/wiki/API_GetShapeshiftFormID (forms, stealth, wolf, stance, etc)
  GetShapeshiftFormID = GetShapeshiftFormID,
  GetXP = function() return UnitXP("player") end,
  GetXPExhaustion = function() return GetXPExhaustion() end,
  GetXPPercent = function(self) return self:GetXP() / self:GetMaxXP() end,
  HasTarget = function() return UnitExists("target") end,
  HasToy = PlayerHasToy,
  InCombat = InCombatLockdown,
  IsAFK = function() return UnitIsAFK("player") end,
  isMaxLevel = function(self) return self:GetLevel() == wow.maxLevel end,
  isRested = function() return 1 == GetRestState() end,
  IsResting = IsResting,
  IsMountUsable = function(id)
    local _, _, _, _, usable = C_MountJournal.GetMountInfoByID(id)
    return usable
  end,
  IsMountCollected = function(id)
    local _, _, _, _, _, _, _, _, _, _, collected = C_MountJournal.GetMountInfoByID(id)
    return collected
  end,
  IsSpellKnown = IsSpellKnown,
  Mount = C_MountJournal.SummonByID,
  UseToy = UseToy,
}
ns.wow.Player = Player

function Player:GetRestPercent()
  if not self:isRested() then return 0 end
  local maxXP = self:GetMaxXP()
  return max(0, self:GetXPExhaustion() / 2 / maxXP)
end

local Profession = {}
function Profession:GetInfo()
  if not self.id then return nil end
  local name, icon, skillLvl, x, abils, offset, skillID, skillMod, specIdx, specOffset, v = GetProfessionInfo(self.id)
  return {
    id = self.id,
    name = name,
    icon = icon,
    skillLevel = skillLvl,
    maxSkill = x,
    skillID = skillID,
    skillMod = skillMod,
    numAbilities = abils,
    spellOffset = offset,
    specializationIndex = specIdx,
    specializationOffset = specOffset,
    isKhazAlgar = "Khaz Algar Fishing" == v or "Khaz Algar Cooking" == v
  }
end

function Player:GetProfessions()
  if not self.professions then
    local prof1, prof2, arch, fishing, cooking = GetProfessions()
    self.professions = {
      prof1 = Mixin({id = prof1}, Profession),
      prof2 = Mixin({id = prof2}, Profession),
      archaeology = Mixin({id = arch}, Profession),
      fishing = Mixin({id = fishing}, Profession),
      cooking = Mixin({id = cooking}, Profession),
    }
  end
  return self.professions
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

function Player:GetRewardOptions()
  local rewards, counts, best, bestN = ns.wow.GreatVault.getRewardOptions()
  return {
    rewards = rewards,
    counts = counts,
    best = best,
    bestN = bestN,
  }
end
