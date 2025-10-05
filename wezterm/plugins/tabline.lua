local wezterm = require("wezterm") --[[@as Wezterm]]

local M = {}

local bg = "#101010"
local blue = "#83adc3"
local yellow = "#d8a16c"

M.setup = function(config)
	local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
	tabline.setup({
		options = {
			icons_enabled = true,
			theme = "Gruvbox Material (Gogh)",
			theme_overrides = {
				normal_mode = {
					a = { fg = bg, bg = blue },
					b = { fg = "#ffffff", bg = "#1f1f1f" },
					c = { fg = "#c6b6ee", bg = bg },
				},
				-- 	copy_mode = {
				-- 		a = { fg = bg, bg = yellow },
				-- 		b = { fg = yellow, bg = "#1f1f1f" },
				-- 		c = { fg = "#c6b6ee", bg = "#151515" },
				-- 	},
				-- 	search_mode = {
				-- 		a = { fg = "#000000", bg = "#d2ebbe" },
				-- 		b = { fg = "#d2ebbe", bg = "#313244" },
				-- 		c = { fg = "#c6b6ee", bg = "#151515" },
				-- 	},
				-- 	window_mode = {
				-- 		a = { fg = bg, bg = "#cba8f7" },
				-- 		b = { fg = "#cba6f7", bg = "#313244" },
				-- 		c = { fg = "#cdd6f4", bg = "#181825" },
				-- 	},
				move_tab_mode = {
					a = { fg = bg, bg = "#cba8f7" },
					b = { fg = "#cba6f7", bg = "#313244" },
					c = { fg = "#cdd6f4", bg = "#181825" },
				},
				resize_pane_mode = {
					a = { fg = bg, bg = "#cba8f7" },
					b = { fg = "#cba6f7", bg = "#313244" },
					c = { fg = "#cdd6f4", bg = "#181825" },
				},

				tab = {
					active = { fg = bg, bg = yellow },
					inactive = { fg = "#cdd6f4", bg = bg },
					inactive_hover = { fg = "#f5c2e7", bg = "#181825" },
				},
			},
			section_separators = {
				left = wezterm.nerdfonts.pl_left_hard_divider,
				right = wezterm.nerdfonts.pl_right_hard_divider,
			},
			component_separators = {
				left = wezterm.nerdfonts.pl_left_soft_divider,
				right = wezterm.nerdfonts.pl_right_soft_divider,
			},
			tab_separators = {
				left = wezterm.nerdfonts.pl_left_hard_divider,
				right = wezterm.nerdfonts.pl_right_hard_divider,
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
							return "| " .. window:active_key_table()
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
						return "| " .. workspace
					end,
				},
			},
			tabline_c = {
				-- " "
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
			tabline_x = { "" },
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
	config.hide_tab_bar_if_only_one_tab = false
	config.window_decorations = "NONE"

	tabline.apply_to_config(config)
end

return M
