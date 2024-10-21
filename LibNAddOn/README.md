# LibNAddOn

`LibNAddON` is an addOn for bootstrapping other addOns. It provides a single global function
that takes a table of options, detailed below.

## Usage

List it in your `.toc`:

```World of Warcraft Addon Data
## Dependencies: LibNAddOn
```

A minimal example:

```lua
local ADDON_NAME, ns = ...

LibNAddOn{
  name = ADDON_NAME,
  addOn = ns,
}
```

Which adds the following to your addon namespace `ns`:

### function Print(...)

Prints any passed arguments, with `<ADDON_NAME>:` prepended.

### an EventListener

Adds a lightweight hidden frame on `_eventListener` and two functions:

#### registerEvent(eventName, handlerFn?, idx?)

If no handler function is given, hooks up the event to call `ns.EVENT_NAME()`.

If a handler function _is_ provided, hooks up the event to call it, bound to the addon.

If `idx` is specified, inserts the handler at the specific index. Generally used to
make sure the handler is called before other previously registered handlers (by passing
1 as the idx).

#### unregisterEvent(eventName, handlerFn?)

If `handlerFn` is provided, removes the specified callback.

If `handlerFn` is _not_ provided, removes **all** callbacks.

### An event handler for ADDON_LOADED

Calls `ns.onLoad` when the event is fired for `ADDON_NAME`.

If `ns.onLogin` is defined, registers for the event `PLAYER_ENTERING_WORLD`, calling
`ns.onLogin` if it was a login or reload event.

### Globals

Links most of the global wow functions, including convenience wrappers for some.

#### `ns.Colors`

Contains constants for a lot of colors used in the default UI.

#### `ns.lua`

Links some of the basic functions WoW defines, and a few other basic lua functions.

Includes the `Class` function for defining inheritable, instantiatable objects.

#### `ns.wow`

Links WoW API functions, wrapping/extending some for convenience.

#### `ns.wowui`

Links WoW Widget API functions, wrapper/extending some for convenience.
