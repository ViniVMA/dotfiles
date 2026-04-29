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

return {
  dir = vim.fn.stdpath("config"),
  name = "tmux-claude",
  cond = function()
    return vim.env.TMUX ~= nil
  end,
  keys = {
    {
      "<leader>aS",
      send_review_comments,
      desc = "Send Review Comments to tmux Claude",
    },
  },
}
