local wezterm = require("wezterm") --[[@as Wezterm]]
local utils = require("lib.utils")

local M = {}

-- Koda dark colors
local dark = {
	bg = "#101010",
	bg_alt = "#1f1f1f",
	fg = "#ffffff",
	fg_dim = "#a5adce",
	accent = "#5abfb5", -- cyan
	yellow = "#d9ba73",
	pink = "#f4b8e4",
	green = "#a3d6a3",
}

-- Koda light colors
local light = {
	bg = "#faf9f5",
	bg_alt = "#e8e7e3",
	fg = "#3a3a3a",
	fg_dim = "#6a6a6a",
	accent = "#007d7d", -- cyan
	yellow = "#926200",
	pink = "#a200d1",
	green = "#407f00",
}

local colors = utils.scheme_for_appearance(wezterm.gui.get_appearance(), dark, light)

M.setup = function(config)
	local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
	tabline.setup({
		options = {
			icons_enabled = true,
			theme_overrides = {
				normal_mode = {
					a = { fg = colors.bg, bg = "#a5adce" },
					b = { fg = "#a5adce", bg = "#000000" },
					c = { fg = colors.bg, bg = "#ffffff" },
					x = { fg = colors.bg, bg = "#ffffff" },
					y = { fg = "#ffffff", bg = "#000000" },
					z = { fg = colors.bg, bg = "#a5adce" },
				},
				copy_mode = {
					a = { fg = colors.bg, bg = "#ff5733" },
					b = { fg = "#ff5733", bg = "#000000" },
					c = { fg = colors.bg, bg = "#ffffff" },
					x = { fg = colors.bg, bg = "#ffffff" },
					y = { fg = "#ffffff", bg = "#000000" },
					z = { fg = colors.bg, bg = "#ff5733" },
				},
				search_mode = {
					a = { fg = colors.bg, bg = "#8ec772" },
					b = { fg = "#8ec772", bg = "#000000" },
					c = { fg = colors.bg, bg = "#ffffff" },
					x = { fg = colors.bg, bg = "#ffffff" },
					y = { fg = "#ffffff", bg = "#000000" },
					z = { fg = colors.bg, bg = "#8ec772" },
				},
				move_tab_mode = {
					a = { fg = colors.bg, bg = "#f2a4db" },
					b = { fg = "#f2a4db", bg = "#000000" },
					c = { fg = colors.bg, bg = "#ffffff" },
					x = { fg = colors.bg, bg = "#ffffff" },
					y = { fg = "#ffffff", bg = "#000000" },
					z = { fg = colors.bg, bg = "#f2a4db" },
				},
				resize_pane_mode = {
					a = { fg = colors.bg, bg = "#ff7676" },
					b = { fg = "#ff7676", bg = "#000000" },
					c = { fg = colors.bg, bg = "#ffffff" },
					x = { fg = colors.bg, bg = "#ffffff" },
					y = { fg = "#ffffff", bg = "#000000" },
					z = { fg = colors.bg, bg = "#ff7676" },
				},

				tab = {
					active = { fg = "#ffffff", bg = "#000000" },
					inactive = { fg = "#000000", bg = "#ffffff" },
					inactive_hover = { fg = "#ffffff", bg = "#000000" },
				},
			},
			section_separators = {
				left = wezterm.nerdfonts.ple_lower_left_triangle,
				right = wezterm.nerdfonts.ple_upper_right_triangle,
			},
			component_separators = {
				left = wezterm.nerdfonts.pl_left_soft_divider,
				right = wezterm.nerdfonts.pl_right_soft_divider,
			},
			tab_separators = {
				left = wezterm.nerdfonts.ple_lower_left_triangle,
				right = wezterm.nerdfonts.ple_upper_right_triangle,
			},
		},
		sections = {
			tabline_a = {
				-- {
				-- 	"mode",
				-- 	padding = { left = 1, right = 2 },
				-- 	-- 	if window:leader_is_active() then
				-- 	-- 		return wezterm.nerdfonts.md_keyboard_outline .. " LDR"
				-- 	-- 	elseif mode == "NORMAL" then
				-- 	-- 		return wezterm.nerdfonts.cod_terminal
				-- 	-- 	elseif mode == "COPY" then
				-- 	-- 		return wezterm.nerdfonts.md_scissors_cutting
				-- 	-- 	elseif mode == "SEARCH" then
				-- 	-- 		return wezterm.nerdfonts.oct_search
				-- 	-- 	end
				-- 	--
				-- 	-- 	return mode
				-- 	-- end,
				-- },
			},
			tabline_b = {
				{
					"workspace",
					fmt = function(workspace, window)
						if window:active_key_table() then
							return "| " .. string.upper(window:active_key_table():gsub("_mode$", ""))
						end
						if window:leader_is_active() then
							-- tabline.set_theme({
							-- 	normal_mode = {
							-- 		b = { fg = "#000000", bg = "#ffffff" },
							-- 	},
							-- })
							return "| " .. "LDR"
						end
						-- tabline.set_theme({
						-- 	normal_mode = {
						-- 		a = { fg = bg, bg = blue },
						-- 		b = { fg = blue, bg = "#1f1f1f" },
						-- 		c = { fg = "#c6b6ee", bg = bg },
						-- 	},
						-- }) -- reset to default theme
						return "| " .. string.upper(workspace)
					end,
				},
			},
			tab_active = {
				"index",
				-- { "parent", padding = 0 },
				-- "/",
				{ "cwd", padding = { left = 0, right = 1 } },
				{ "zoomed", padding = 0 },
			},
			tab_inactive = {
				"index",
				-- { "process", padding = { left = 0, right = 1 } },
				{ "cwd", padding = { left = 0, right = 1 } },
			},
			tabline_x = {},
			tabline_y = {
				"ram",
				"cpu",
				"datetime",
				"battery",
			},
			tabline_z = {

				-- "hostname"
			},
		},
		extensions = {},
	})

	-- specific tabline config
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = false
	config.hide_tab_bar_if_only_one_tab = true
	config.window_decorations = "NONE"

	tabline.apply_to_config(config)
end

return M
