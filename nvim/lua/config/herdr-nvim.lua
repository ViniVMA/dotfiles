local M = {}

local agents = require("herdr-nvim.agents")
local exec_mod = require("herdr-nvim.exec")

local function axis_bounds(siblings, axis)
  local min_value, max_value
  for _, sibling in ipairs(siblings) do
    local value = sibling.rect and sibling.rect[axis]
    if type(value) == "number" then
      min_value = min_value and math.min(min_value, value) or value
      max_value = max_value and math.max(max_value, value) or value
    end
  end
  return min_value, max_value
end

local function pane_position(info)
  local rect = info.rect
  local area = info.area
  local siblings = info.siblings
  if type(rect) ~= "table" or type(siblings) ~= "table" or #siblings < 2 then
    return nil
  end

  local min_x, max_x = axis_bounds(siblings, "x")
  local min_y, max_y = axis_bounds(siblings, "y")
  if not min_x or not max_x or not min_y or not max_y then
    return nil
  end

  local spans_full_height = area
      and type(area.height) == "number"
      and type(rect.height) == "number"
      and rect.height >= area.height * 0.9
  local spans_full_width = area
      and type(area.width) == "number"
      and type(rect.width) == "number"
      and rect.width >= area.width * 0.9

  local parts = {}
  if not spans_full_height and min_y ~= max_y then
    parts[#parts + 1] = rect.y == min_y and "top" or (rect.y == max_y and "bottom" or nil)
  end
  if not spans_full_width and min_x ~= max_x then
    parts[#parts + 1] = rect.x == min_x and "left" or (rect.x == max_x and "right" or nil)
  end

  return #parts > 0 and table.concat(parts, "-") or nil
end

local function read_snapshot(run)
  local result = run({ "herdr", "api", "snapshot" })
  if result.code ~= 0 then
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, result.stdout)
  if not ok or type(decoded) ~= "table" then
    return nil
  end

  local snapshot = decoded.result and decoded.result.snapshot
  return type(snapshot) == "table" and snapshot or nil
end

local function enrich_agents(agent_list, snapshot)
  local layout_by_pane = {}
  for _, layout in ipairs(snapshot.layouts or {}) do
    for _, pane in ipairs(layout.panes or {}) do
      layout_by_pane[pane.pane_id] = {
        area = layout.area,
        rect = pane.rect,
        siblings = layout.panes,
        tab_id = layout.tab_id,
      }
    end
  end


  local tabs = {}
  for _, tab in ipairs(snapshot.tabs or {}) do
    tabs[tab.tab_id] = tab
  end

  for _, agent in ipairs(agent_list) do
    local info = layout_by_pane[agent.pane_id]
    if info then
      agent.position = pane_position(info)
      agent.tab_id = info.tab_id
    end

    local tab = tabs[agent.tab_id]
    if tab then
      agent.tab_label = tab.label
      agent.tab_number = tab.number
    end
  end
end

function M.setup()
  if M._installed then
    return
  end

  local original_list = agents.list
  agents.list = function(run)
    local agent_list, err = original_list(run)
    if not agent_list then
      return nil, err
    end

    local snapshot = read_snapshot(run or exec_mod.default_exec)
    if snapshot then
      enrich_agents(agent_list, snapshot)
    end
    return agent_list
  end

  agents.display = function(agent)
    local tail = vim.fn.fnamemodify(agent.cwd, ":t")
    local position = agent.position or "full"
    local tab = agent.tab_label or agent.tab_id or "tab"
    return string.format("%s · %s · %s · %s", agent.kind, agent.status, position, tab .. "/" .. tail)
  end

  M._installed = true
end

return M
