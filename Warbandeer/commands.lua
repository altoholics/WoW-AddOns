local _, ns = ...

function ns:SlashCmd(_, msg) -- cmd, msg
  local _, _, cmd = string.find(msg, "(%w+) ?(.*)") --, args
  if cmd == nil then
    self:Open()
  elseif "summary" == cmd then
    self:view("summary")
  elseif "raceGrid" == cmd then
    self:view("raceGrid")
  elseif "alliance" == cmd then
    self:view("raceGrid")
    self.MainWindow.views.raceGrid:showAlliance()
  elseif "horde" == cmd then
    self:view("raceGrid")
    self.MainWindow.views.raceGrid:showHorde()
  elseif "detail" == cmd then
    self:view("detail")
  end
end
