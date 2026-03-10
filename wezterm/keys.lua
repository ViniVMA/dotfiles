local wezterm = require("wezterm") --[[@as Wezterm]]

local act = wezterm.action

-- Multiplexing is handled by Zellij.
-- WezTerm only handles terminal-level concerns here.

---@type StrictConfig
return {
	keys = {
		{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\n" }) },
		{ key = "Space", mods = "CTRL", action = wezterm.action({ SendString = "\x00" }) },
		{ key = ".", mods = "ALT", action = act.ActivateCommandPalette },
		{ key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
	},
	mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "SHIFT",
			action = wezterm.action_callback(function(window, pane)
				local has_selection = window:get_selection_text_for_pane(pane) ~= ""
				if has_selection then
					window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
					window:perform_action(act.ClearSelection, pane)
				else
					window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
				end
			end),
		},
	},
}
