# LibNUI

A library of UI classes wrapping Blizzard's frames and adding convenience and
quality of life features.

## Usage

List it in your `.toc`:

```World of Warcraft Addon Data
## Dependencies: LibNUI
```

then you may want to make local copies of the globals for performance or a shorter reference:

```lua
local PortraitFrame = LibNUI.PortraitFrame
```

Then, build your UI!

```lua
local pf = PortraitFrame:new{
    name = addOnName,
    portraitPath = "Interface\\Icons\\achievement_bg_killflagcarriers_grabflag_capit.blp",
}
pf:center()
pf:size(600, 400)
```

## FrameColor

LibNUI has built-in support for FrameColor, and will automatically create modules for supported
frames. You will be able to configure them in FrameColor's settings, just like you can with the
default frames.

## Clean Frames

`CleanFrame` is a generic frame with a blurred edge border matching Tooltips (it uses UI-Tooltip-Border)
and a clean background. It is intended to provide a basic start point for a clean looking frame.

### TitleFrame

Built on `CleanFrame`, `TitleFrame` adds a titlebar with an icon, text, and a close button. Clicking on
the close button hides the frame, and dragging the titlebar moves the frame.
