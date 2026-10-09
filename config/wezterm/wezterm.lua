-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

config.keys = {
  --paste from the clipboard
  { key = 'V', mods = 'CMD', action = act.PasteFrom 'Clipboard'},
  
  -- paste from the primary selection
  { key = 'V', mods = 'CMD', action = act.PasteFrom 'PrimarySelection'},

  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = false } },
  { key = 'w', mods = 'CTRL', action = act.CloseCurrentPane { confirm = false } },
  { key = 'p', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },
}

-- This is where you actually apply your config choices.
-- Config details taken from https://medium.com/@vladkens/from-iterm-to-wezterm-24db2ccb8dc1

-- appearance

config.font = wezterm.font {
  family = 'JetBrains Mono',
  weight = 'Medium',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- disable ligatures
}
config.font_size = 12.0
config.line_height = 1.0

--theme
function scheme_for_appearance(appearance)
  return "Catppuccin Mocha"
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
-- config.color_scheme = "Catppuccin Mocha" -- or Macchiato, Frappe, Latte
-- padding

config.window_padding = { left = '0', right = '0', top = '0', bottom = '1cell' }
config.default_cursor_style = 'BlinkingUnderline'

config.animation_fps = 1
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'


-- window style

config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.hide_tab_bar_if_only_one_tab = true

-- Finally, return the configuration to wezterm:
return config

