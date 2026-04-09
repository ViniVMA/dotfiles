local function find_claude_direction()
  local layout = vim.fn.system("zellij action dump-layout")
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local lines = vim.split(layout, "\n")

  -- Find the focused tab's line range
  local tab_start, tab_end, tab_indent
  for i, line in ipairs(lines) do
    if line:match("^%s*tab ") and line:find("focus=true") then
      tab_start = i
      tab_indent = #(line:match("^(%s*)"))
      break
    end
  end
  if not tab_start then
    return nil
  end
  for i = tab_start + 1, #lines do
    local indent = #(lines[i]:match("^(%s*)"))
    if indent <= tab_indent and lines[i]:match("%S") then
      tab_end = i - 1
      break
    end
  end
  tab_end = tab_end or #lines

  -- Search only within the focused tab
  local focus_line, claude_line, focus_indent, claude_indent
  for i = tab_start, tab_end do
    local line = lines[i]
    local indent = #(line:match("^(%s*)"))
    if not focus_line and line:match("^%s*pane ") and line:find("focus=true") then
      focus_line, focus_indent = i, indent
    end
    if not claude_line and line:match("^%s*pane ") then
      local is_claude = line:find('command="claude"')
      if not is_claude then
        local next = lines[i + 1]
        if next and next:match("^%s*args ") and next:find('"claude') then
          is_claude = true
        end
      end
      if is_claude then
        claude_line, claude_indent = i, indent
      end
    end
  end

  if not focus_line or not claude_line then
    return nil
  end

  -- Walk backward from the earlier pane to find the common parent's split_direction
  local min_indent = math.min(focus_indent, claude_indent)
  local split_dir
  for i = math.min(focus_line, claude_line) - 1, 1, -1 do
    local indent = #(lines[i]:match("^(%s*)"))
    if indent < min_indent then
      local dir = lines[i]:match('split_direction="(%w+)"')
      if dir then
        split_dir = dir
        break
      end
      min_indent = indent
    end
  end

  if not split_dir then
    return nil
  end

  if split_dir == "vertical" then
    return focus_line < claude_line and "right" or "left"
  else
    return focus_line < claude_line and "down" or "up"
  end
end

local function send_to_zellij(text, direction)
  -- Focus the Claude pane
  vim.fn.system("zellij action move-focus " .. direction)

  -- Build byte sequence: bracketed paste start + text + bracketed paste end
  local bytes = { 27, 91, 50, 48, 48, 126 } -- ESC[200~
  for i = 1, #text do
    bytes[#bytes + 1] = string.byte(text, i)
  end
  local paste_end = { 27, 91, 50, 48, 49, 126 } -- ESC[201~
  for _, b in ipairs(paste_end) do
    bytes[#bytes + 1] = b
  end

  vim.fn.system("zellij action write " .. table.concat(bytes, " "))
end

local function send_prompt()
  local Config = require("sidekick.config")
  local Context = require("sidekick.cli.context")

  local direction = find_claude_direction()
  if not direction then
    vim.notify("No Claude pane found in current Zellij tab", vim.log.levels.WARN)
    return
  end

  local prompt_names = vim.tbl_keys(Config.cli.prompts)
  table.sort(prompt_names)

  -- Capture context now (includes visual selection if in visual mode)
  local context = Context.get()

  -- Build items with pre-resolved text
  local items = {}
  for _, name in ipairs(prompt_names) do
    local text = context:render({ prompt = name })
    if text and text ~= "" then
      items[#items + 1] = { name = name, text = text }
    end
  end

  if #items == 0 then
    vim.notify("No prompts could be resolved", vim.log.levels.WARN)
    return
  end

  vim.ui.select(items, {
    prompt = "Send to Zellij Claude:",
    format_item = function(item)
      local tpl = Config.cli.prompts[item.name]
      tpl = type(tpl) == "string" and tpl or (type(tpl) == "table" and tpl.msg or "[function]")
      return ("[%s] %s"):format(item.name, tpl)
    end,
  }, function(choice)
    if not choice then
      return
    end
    send_to_zellij(choice.text, direction)
    vim.notify("Sent to Claude: " .. choice.name, vim.log.levels.INFO)
  end)
end

return {
  dir = vim.fn.stdpath("config"),
  name = "zellij-claude",
  cond = function()
    return vim.env.ZELLIJ ~= nil
  end,
  keys = {
    {
      "<leader>ap",
      send_prompt,
      desc = "Send Prompt to Zellij Claude",
      mode = { "n", "v" },
    },
  },
}
