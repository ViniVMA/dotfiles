local utils = require("lib.utils")
local wezterm = require("wezterm") --[[@as Wezterm]]

local light = "Gruvbox Material (Gogh)"
local dark = "Gruvbox Material (Gogh)"

---@type StrictConfig
return {
	color_scheme = utils.scheme_for_appearance(wezterm.gui.get_appearance(), dark, light),
	color_scheme_dirs = { "~/.config/wezterm/colors/" },
}
