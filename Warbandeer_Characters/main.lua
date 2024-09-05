local _, ns = ...

local UnitName, UnitLevel, UnitClassBase, UnitRace = ns.g.UnitName, ns.g.UnitLevel, ns.g.UnitClassBase, ns.g.UnitRace
local GetAverageItemLevel = ns.g.GetAverageItemLevel

function ns:PLAYER_ENTERING_WORLD(login, reload)
  if not (login or reload) then return end

  local name = UnitName("player")
  local level = UnitLevel("player")
  local _, classId = UnitClassBase("player")
  local _, raceFile, raceId = UnitRace("player")
  local _, ilvl = GetAverageItemLevel()

  local data = self.db.characters
  if not data[name] then data[name] = {} end

  self.currentPlayer = name
  data[name].classId = classId
  data[name].level = level
  data[name].race = raceFile
  data[name].raceId = raceId
  data[name].ilvl = ilvl
end
ns:registerEvent("PLAYER_ENTERING_WORLD")

function ns:PLAYER_LEVEL_UP()
  local data = self.db.characters[self.currentPlayer]
  data.level = UnitLevel("player")
end
ns:registerEvent("PLAYER_LEVEL_UP")

function ns:PLAYER_EQUIPMENT_CHANGED()
  local _, ilvl = GetAverageItemLevel()
  local data = self.db.characters[self.currentPlayer]
  data.ilvl = ilvl
end
ns:registerEvent("PLAYER_EQUIPMENT_CHANGED")

function ns.api:GetCurrentCharacter() return self.currentPlayer end

function ns.api:GetCharacterData(char)
  -- todo: return a copy so it is immutable
  return ns.db.characters[char or self.currentPlayer]
end

function ns.api.GetAllCharacters()
  -- todo: return a copy so it is immutable
  return ns.db.characters
end
