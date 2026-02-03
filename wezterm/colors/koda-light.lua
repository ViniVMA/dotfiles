local M = {}

function M.colors()
	return {
		foreground = "#3a3a3a",
		background = "#faf9f5",

		cursor_bg = "#6a6a6a",
		cursor_fg = "#f1f1f1",
		cursor_border = "#6a6a6a",

		selection_fg = "#f1f1f1",
		selection_bg = "#3a3a3a",

		scrollbar_thumb = "#d0d0d0",
		split = "#d0d0d0",

		ansi = {
			"#e2e2e2",
			"#ca0043",
			"#407f00",
			"#926200",
			"#006acf",
			"#a200d1",
			"#007d7d",
			"#6a6a6a",
		},
		brights = {
			"#ababab",
			"#f30052",
			"#4f9a00",
			"#b07700",
			"#0081f8",
			"#c301fb",
			"#009797",
			"#222222",
		},
		tab_bar = {
			background = "#faf9f5",
			active_tab = {
				bg_color = "#e8e7e3",
				fg_color = "#3a3a3a",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = "#faf9f5",
				fg_color = "#ababab",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab_hover = {
				bg_color = "#e8e7e3",
				fg_color = "#3a3a3a",
				italic = false,
			},
			new_tab = {
				bg_color = "#faf9f5",
				fg_color = "#006acf",
			},
			new_tab_hover = {
				bg_color = "#e8e7e3",
				fg_color = "#0081f8",
			},
			inactive_tab_edge = "#d0d0d0",
		},
	}
end

function M.window_frame()
	return {
		active_titlebar_bg = "#faf9f5",
		inactive_titlebar_bg = "#faf9f5",
	}
end

return M
