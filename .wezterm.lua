-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.default_prog = { "nu" }
-- for example, changing the color scheme:
-- config.color_scheme = "gruvbox dark (gogh)"
-- config.color_scheme = "catppuccin-frappe"
config.color_scheme = "Catppuccin Frappé (Gogh)"

-- config.enable_tab_bar = false
-- config.window_decorations = "title"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 2,
	right = 0,
	top = 0,
	bottom = 0,
}

-- and finally, return the configuration to wezterm
return config
