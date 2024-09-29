local _, ns = ...
local API = ns.api

local tinsert = ns.lua.tinsert
local UnitName, UnitLevel, UnitClassBase, UnitRace = ns.wow.UnitName, ns.wow.UnitLevel, ns.wow.UnitClassBase, ns.wow.UnitRace
local GetClassInfo, GetProfessions, GetProfessionInfo = ns.wow.GetClassInfo, ns.wow.GetProfessions, ns.wow.GetProfessionInfo
local GetAverageItemLevel = ns.wow.GetAverageItemLevel

local function getProfessionInfo(profID)
  local name, icon, skillLvl, max, abils, offset, skillID, skillMod, specIdx, specOffset = GetProfessionInfo(profID)
  return {
    id = profID,
    name = name,
    icon = icon,
    skillLevel = skillLvl,
    maxSkill = max,
    skillID = skillID,
    skillMod = skillMod,
    numAbilities = abils,
    spellOffset = offset,
    specializationIndex = specIdx,
    specializationOffset = specOffset,
  }
end

function ns:onLogin()
  local name = UnitName("player")
  local level = UnitLevel("player")
  local _, classId = UnitClassBase("player")
  local _, raceFile, raceId = UnitRace("player")
  local _, ilvl = GetAverageItemLevel()
  local className = GetClassInfo(classId)
  local raceIndex, isAlliance = ns.NormalizeRaceId(raceId)

  local data = self.db.characters
  if not data[name] then
    data[name] = ns.Data.newCharacter()
    self.db.numCharacters = self.db.numCharacters + 1
  end
  local c = data[name]

  self.currentPlayer = name
  c.name = name
  c.classId = classId
  c.className = className
  c.level = level
  c.race = raceFile
  c.raceId = raceId
  c.raceIdx = raceIndex
  c.isAlliance = isAlliance
  c.ilvl = math.floor(ilvl)
  c.realm = ns.wow.RealmName

  local prof1, prof2, _, fishingIdx, cookingIdx = GetProfessions() -- arch
  c.prof1 = prof1 and getProfessionInfo(prof1)
  c.prof2 = prof2 and getProfessionInfo(prof2)
  if fishingIdx then
    local _, _, skill, max, _, _, _, skillMod, _, v = GetProfessionInfo(fishingIdx)
    c.fishing = c.fishing or {}
    c.fishing.skillLevel = skill
    c.fishing.maxSkill = max
    c.fishing.skillMod = skillMod
    c.fishing.version = v
    c.fishing.isKhazAlgar = "Khaz Algar Fishing" == v
  end
  if cookingIdx then
    local _, _, skill, max, _, _, _, skillMod, _, v = GetProfessionInfo(cookingIdx)
    c.cooking = c.cooking or {}
    c.cooking.skillLevel = skill
    c.cooking.maxSkill = max
    c.cooking.skillMod = skillMod
    c.cooking.version = v
    c.cooking.isKhazAlgar = "Khaz Algar Cooking" == v
  end
end

function ns:PLAYER_LEVEL_UP()
  local data = self.db.characters[self.currentPlayer]
  data.level = UnitLevel("player")
end
ns:registerEvent("PLAYER_LEVEL_UP")

function ns:PLAYER_EQUIPMENT_CHANGED()
  local _, ilvl = GetAverageItemLevel()
  local data = self.db.characters[self.currentPlayer]
  data.ilvl = math.floor(ilvl)
end
ns:registerEvent("PLAYER_EQUIPMENT_CHANGED")

function API:GetCurrentCharacter() return ns.currentPlayer end

function API:GetCharacterData(char)
  -- todo: return a copy so it is immutable
  return ns.db.characters[char or ns.currentPlayer]
end

function API:GetNumCharacters() return ns.db.numCharacters end
function API:GetNumMaxLevel()
  local n = 0
  for _,c in pairs(ns.db.characters) do
    if c.level == ns.wow.maxLevel then n = n + 1 end
  end
  return n
end

function API:GetAllCharacters()
  local list = {}
  for _,c in pairs(ns.db.characters) do tinsert(list, c) end
  return list
end

function API:GetAllianceCharacters()
  local c = {}
  for _,t in pairs(ns.db.characters) do
    if t.isAlliance then table.insert(c, t) end
  end
  return c
end

function API:GetHordeCharacters()
  local c = {}
  for _,t in pairs(ns.db.characters) do
    if not t.isAlliance then table.insert(c, t) end
  end
  return c
end
