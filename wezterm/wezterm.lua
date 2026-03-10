local utils = require("lib.utils")
local wezterm = require("wezterm") --[[@as Wezterm]]

---@type StrictConfig
local config = {}

local appearance = require("appearance")
local behavior = require("behavior")
local colors = require("colors")
local keys = require("keys")

for _, module in ipairs({
	appearance,
	behavior,
	colors,
	keys,
}) do
	utils.merge_tables(config, module)
end

if utils.is_windows() then
	utils.merge_tables(config, require("windows_overrides"))
end

return config
