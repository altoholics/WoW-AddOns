local ADDON_NAME, ns = ...

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
  slashCommands = {
    libnui = {"/libnui", "/nui"}
  },
}

ns.ui = {}
LibNUI = ns.ui


function ns:SlashCmd(_, msg) -- cmd, msg
  local _, _, cmd = string.find(msg, "(%w+) ?(.*)") --, args
  if "tabletest" == cmd then
    ns.ui.TableFrame:new{
      position = {
        Center = {},
        Width = 140,
        Height = 140
      },
      colNames = {"A", "B", "C"},
      colInfo = {
        {width = 20, backdrop = {color = {1, 0, 0, 0.5}}},
        {width = 40, backdrop = {color = {0, 1, 0, 0.5}}},
        {width = 60, backdrop = {color = {0, 0, 1, 0.5}}},
      },
      rowNames = {"A", "B", "C"},
      rowInfo = {
        {height = 20, backdrop = {color = {1, 0, 0, 0.5}}},
        {height = 40, backdrop = {color = {0, 1, 0, 0.5}}},
        {height = 60, backdrop = {color = {0, 0, 1, 0.5}}},
      },
      headerWidth = 20,
    }
    :addCol({name = "D", width = 40, backdrop = {color = {0.5, 0.5, 0, 0.5}}})
    :addRow({name = "D", height = 40, backdrop = {color = {0.5, 0.5, 0, 0.5}}})
  end
end
