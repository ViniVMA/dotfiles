local utils = require("lib.utils")
local wezterm = require("wezterm") --[[@as Wezterm]]

local koda = require("colors.koda")
local koda_light = require("colors.koda-light")

---@type StrictConfig
return {
	colors = utils.scheme_for_appearance(wezterm.gui.get_appearance(), koda.colors(), koda_light.colors()),
	window_frame = utils.scheme_for_appearance(wezterm.gui.get_appearance(), koda.window_frame(), koda_light.window_frame()),
}
