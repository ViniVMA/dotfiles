local wezterm = require("wezterm") --[[@as Wezterm]]

-- Event handler to update status when leader key state changes
-- wezterm.on("update-right-status", function(window, pane)
-- 	-- This will trigger a refresh of the tab bar when leader state changes
-- 	if window:leader_is_active() then
-- 		-- Force a refresh by updating window title
-- 		window:set_right_status("")
-- 	end
-- end)

-- Custom event to handle mode changes for tabline
wezterm.on("leader-key-activated", function(window, pane)
	-- Trigger a refresh of the tab bar
	window:set_right_status("")
end)

wezterm.on("leader-key-deactivated", function(window, pane)
	-- Trigger a refresh of the tab bar
	window:set_right_status("")
end)

---@type StrictConfig
return {}
