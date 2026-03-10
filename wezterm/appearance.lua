local fonts = require("lib.fonts")
local wezterm = require("wezterm") --[[@as Wezterm]]

---@type StrictConfig
return {
	font_size = 15,
	font = wezterm.font_with_fallback({
		fonts.geist_mono,
		fonts.maple_mono,
		fonts.departure_mono,
		fonts.commit_mono,
		fonts.monaspace,
	}),
	adjust_window_size_when_changing_font_size = false,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	default_cursor_style = "BlinkingBlock",
	initial_cols = 114,
	initial_rows = 31,
	window_decorations = "RESIZE",
	window_background_opacity = 0.8,
	macos_window_background_blur = 90,
}
