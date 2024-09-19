local ADDON_NAME, ns = ...

function ns:SlashCmd(_, msg) -- cmd, msg
  local _, _, cmd = string.find(msg, "(%w+) ?(.*)") --, args
  if cmd == nil then
    self:Open()
  elseif "details" == cmd then
    local data = ns.api:GetCharacterData()
    local f = ns.ui.TitleFrame:new{
      parent = UIParent,
      name = ADDON_NAME.."Details",
      title = ADDON_NAME.." | Character details: "..data.name,
      position = {
        width = 500,
        height = 500,
        center = {},
      },
      level = 8000,
    }

    f:withLabel("r", {
      text = data.level.." "..data.race.." "..data.className.." on "..data.realm,
      position = {"TOPLEFT", 5, -35},
    })
    f:withLabel("r2", {
      template = "GameFontHighlightSmall",
      text = "ilvl "..data.ilvl,
      position = {"TOPLEFT", 5, -55},
    })
  end
end
