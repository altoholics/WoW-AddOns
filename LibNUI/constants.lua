local _, ns = ...
local ui = ns.ui
local ToMap = ns.util.ToMap

ui.edge = ToMap({"Top", "Center", "TopLeft", "BottomLeft", "BottomRight"}, string.upper)
ui.layer = ToMap({"Background", "Border", "Artwork", "Overlay", "Highlight"}, string.upper)
ui.wrap = ToMap({"Clamp", "Repeat", "Mirror"}, string.upper)
