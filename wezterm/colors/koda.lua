local M = {}

function M.colors()
	return {
		foreground = "#ffffff",
		background = "#101010",

		cursor_bg = "#efefef",
		cursor_fg = "#000000",
		cursor_border = "#efefef",

		selection_fg = "#ffffff",
		selection_bg = "#333333",

		scrollbar_thumb = "#333333",
		split = "#333333",

		ansi = {
			"#101010",
			"#ff7676",
			"#a3d6a3",
			"#ffffff",
			"#b3b3b3",
			"#f4b8e4",
			"#fafafa",
			"#a5adce",
		},
		brights = {
			"#666666",
			"#ff5733",
			"#8ec772",
			"#d9ba73",
			"#ffffff",
			"#f2a4db",
			"#5abfb5",
			"#b5bfe2",
		},
		tab_bar = {
			background = "#101010",
			active_tab = {
				bg_color = "#252525",
				fg_color = "#ffffff",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = "#101010",
				fg_color = "#666666",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab_hover = {
				bg_color = "#252525",
				fg_color = "#ffffff",
				italic = false,
			},
			new_tab = {
				bg_color = "#101010",
				fg_color = "#b3b3b3",
			},
			new_tab_hover = {
				bg_color = "#252525",
				fg_color = "#ffffff",
			},
			inactive_tab_edge = "#333333",
		},
	}
end

function M.window_frame()
	return {
		active_titlebar_bg = "#101010",
		inactive_titlebar_bg = "#101010",
	}
end

return M
