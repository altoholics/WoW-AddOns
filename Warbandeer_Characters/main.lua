local _, ns = ...

local UnitName, UnitLevel, UnitClassBase, UnitRace = ns.g.UnitName, ns.g.UnitLevel, ns.g.UnitClassBase, ns.g.UnitRace

function ns.EventController:PLAYER_ENTERING_WORLD(login, reload)
  if not (login or reload) then return end

  local name = UnitName("player")
  local level = UnitLevel("player")
  local _, classId = UnitClassBase("player")
  local _, raceFile, raceId = UnitRace("player")

  local data = ns.db.characters
  if not data[name] then data[name] = {} end

  self.currentPlayer = name
  data[name].classId = classId
  data[name].level = level
  data[name].race = raceFile
  data[name].raceId = raceId
end

function ns.api:GetCurrentCharacter() return self.currentPlayer end

function ns.api:GetCharacterData(char)
  -- todo: return a copy so it is immutable
  return ns.db.characters[char or self.currentPlayer]
end

function ns.api.GetAllCharacters()
  -- todo: return a copy so it is immutable
  return ns.db.characters
end
