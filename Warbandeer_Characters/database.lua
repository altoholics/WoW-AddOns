local ADDON_NAME, ns = ...
-- luacheck: globals WarbandeerCharDB

local CopyTable = ns.g.CopyTable

local Data = {}
ns.Data = Data

Data.dbVersion = 2
Data.emptyDB = {
  version = Data.dbVersion,
  numCharacters = 0,
  characters = {},
}

Data.emptyCharacter = {
  name = "",
  classId = "",
  className = "",
  level = 0,
  race = "",
  raceId = -1,
  ilvl = 0,
}

local characterMT = {
  __lt = function(c1, c2)
    return c1.level >= c2.level and c1.ilvl >= c2.ilvl and c1.name > c2.name
  end
}

function Data.newCharacter()
  local c = ns.g.CopyTable(Data.emptyCharacter)
  setmetatable(c, characterMT)
  return c
end

function ns:ADDON_LOADED(name)
  if ADDON_NAME ~= name then return end
  WarbandeerCharDB = WarbandeerCharDB or CopyTable(Data.emptyDB)
  if not WarbandeerCharDB.version then -- if prior to versioning, reset
    WarbandeerCharDB = CopyTable(Data.emptyDB)
  end
  self.db = WarbandeerCharDB
  if self.db.version == 1 then
    local n = 0
    for _ in pairs(self.db.characters) do n = n + 1 end
    self.db.numCharacters = n
    self.db.version = 2
  end
end
ns:registerEvent("ADDON_LOADED")
