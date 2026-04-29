local function find_claude_pane()
  local panes = vim.fn.systemlist("tmux list-panes -F '#{pane_id}\t#{pane_title}'")
  if vim.v.shell_error ~= 0 then
    return nil
  end

  -- Fast path: check pane title for "Claude"
  for _, line in ipairs(panes) do
    local pane_id, title = line:match("^(%S+)\t(.*)$")
    if pane_id and title and title:find("[Cc]laude") then
      return pane_id
    end
  end

  -- Slow path: capture each pane and search for the header text
  for _, line in ipairs(panes) do
    local pane_id = line:match("^(%S+)")
    if pane_id then
      local content = vim.fn.system("tmux capture-pane -p -t " .. pane_id)
      if vim.v.shell_error == 0 and content:find("Claude Code") then
        return pane_id
      end
    end
  end

  return nil
end

local function send_to_tmux(text, pane_id)
  local tmp = vim.fn.tempname()
  local f = io.open(tmp, "w")
  if not f then
    vim.notify("Failed to write temp file", vim.log.levels.ERROR)
    return
  end
  f:write(text)
  f:close()

  vim.fn.system({ "tmux", "load-buffer", tmp })
  vim.fn.system({ "tmux", "paste-buffer", "-p", "-d", "-t", pane_id })
  os.remove(tmp)
end

local function send_review_comments()
  local ok, export = pcall(require, "review.export")
  if not ok then
    vim.notify("review.nvim not loaded", vim.log.levels.WARN)
    return
  end

  local store_ok, store = pcall(require, "review.store")
  if store_ok and store.count() == 0 then
    vim.notify("No review comments to send", vim.log.levels.WARN)
    return
  end

  local pane_id = find_claude_pane()
  if not pane_id then
    vim.notify("No Claude pane found in this window", vim.log.levels.WARN)
    return
  end

  send_to_tmux(export.generate_markdown(), pane_id)
  vim.notify("Sent review comments to Claude", vim.log.levels.INFO)
end

local function send_prompt()
  local Config = require("sidekick.config")
  local Context = require("sidekick.cli.context")

  local pane_id = find_claude_pane()
  if not pane_id then
    vim.notify("No Claude pane found in this window", vim.log.levels.WARN)
    return
  end

  local prompt_names = vim.tbl_keys(Config.cli.prompts)
  table.sort(prompt_names)

  local context = Context.get()

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
    prompt = "Send to tmux Claude:",
    format_item = function(item)
      local tpl = Config.cli.prompts[item.name]
      tpl = type(tpl) == "string" and tpl or (type(tpl) == "table" and tpl.msg or "[function]")
      return ("[%s] %s"):format(item.name, tpl)
    end,
  }, function(choice)
    if not choice then
      return
    end
    send_to_tmux(choice.text, pane_id)
    vim.notify("Sent to Claude: " .. choice.name, vim.log.levels.INFO)
  end)
end

return {
  dir = vim.fn.stdpath("config"),
  name = "tmux-claude",
  cond = function()
    return vim.env.TMUX ~= nil
  end,
  keys = {
    {
      "<leader>ap",
      send_prompt,
      desc = "Send Prompt to tmux Claude",
      mode = { "n", "v" },
    },
    {
      "<leader>aS",
      send_review_comments,
      desc = "Send Review Comments to tmux Claude",
    },
  },
}
