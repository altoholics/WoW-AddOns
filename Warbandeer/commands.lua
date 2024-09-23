local ADDON_NAME, ns = ...

function ns:SlashCmd(_, msg) -- cmd, msg
  local _, _, cmd = string.find(msg, "(%w+) ?(.*)") --, args
  if cmd == nil then
    self:Open()
  elseif "summary" == cmd then
    self:view("summary")
  elseif "details" == cmd then
    local data = ns.api:GetCharacterData()
    local f = ns.ui.TitleFrame:new{
      name = ADDON_NAME.."Details",
      title = ADDON_NAME.." | Character details: "..data.name,
      position = {
        width = 500,
        height = 500,
        center = {},
      },
      level = 8000,
      special = true,
    }

    f:withLabel("r", {
      text = data.level.." "..data.race.." "..data.className.." on "..data.realm,
      position = {topLeft = {5, -35}},
    })
    f:withLabel("r2", {
      font = ns.ui.fonts.GameFontHighlightSmall,
      text = "ilvl "..data.ilvl,
      position = {topLeft = {5, -55}},
    })
  end
end
