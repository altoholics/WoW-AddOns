local _, ns = ...
local ui = ns.ui
local ToMap = ns.util.ToMap

ui.edge = ToMap({
  "Top", "Center", "TopLeft", "TopRight",
  "Bottom", "BottomLeft", "BottomRight",
  "Left", "Right"
}, string.upper)
ui.layer = ToMap({"Background", "Border", "Artwork", "Overlay", "Highlight"}, string.upper)
ui.wrap = ToMap({"Clamp", "Repeat", "Mirror"}, string.upper)
