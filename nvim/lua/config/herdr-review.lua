-- Bridge review.nvim's comments into herdr-context, replacing <leader>as.
--
-- review.nvim ships export.to_sidekick(), which is hard-wired to
-- require("sidekick.cli") — with sidekick disabled it errors out. Its
-- generate_markdown() is public though, so this registers the comments as a
-- herdr-context *provider* (the documented register_provider extension point)
-- and stages it like any builtin. Staging, not submitting: the markdown lands in
-- the agent's prompt and a human presses enter.
--
-- Provider contract, taken from the builtins in
-- ~/.local/share/nvim/lazy/herdr-context.nvim/lua/herdr-context/providers/:
-- collect(request, callback) calls callback(section) on success, or
-- callback(nil, { kind = "unavailable", message = ... }) when there is nothing
-- to stage. `format = "text"` keeps the markdown as-is rather than fencing it as
-- code the way the selection provider does.

local M = {}

local PROVIDER_ID = "review"
local registered = false

local function comment_count(markdown)
  local n = 0
  for _ in markdown:gmatch("\n%s*[-*]%s") do
    n = n + 1
  end
  return n
end

--- Register review comments as a herdr-context provider. Called from the plugin's
--- config, so the source is available inside compose() without its own keybinding.
function M.register()
  if registered then
    return true
  end
  local ok_hc, hc = pcall(require, "herdr-context")
  if not ok_hc then
    vim.notify("herdr-context.nvim is not available", vim.log.levels.ERROR)
    return false
  end

  local ok, err = pcall(hc.register_provider, {
    id = PROVIDER_ID,
    name = "Review comments",
    -- Between hunk (30) and diagnostics; reviews are the point when staged.
    priority = 35,
    collect = function(_, callback)
      local ok_export, export = pcall(require, "review.export")
      if not ok_export then
        callback(nil, { kind = "unavailable", message = "review.nvim is not loaded" })
        return
      end
      local ok_md, markdown = pcall(export.generate_markdown)
      if not ok_md or type(markdown) ~= "string" or markdown:match("^%s*$") then
        callback(nil, { kind = "unavailable", message = "No review comments to send" })
        return
      end
      local count = comment_count(markdown)
      callback({
        id = PROVIDER_ID,
        title = "Review comments",
        summary = ("%d comment%s"):format(count, count == 1 and "" or "s"),
        priority = 35,
        format = "text",
        content = markdown,
        -- Length is enough to notice edits between stagings without hashing.
        fingerprint = PROVIDER_ID .. ":" .. #markdown,
      })
    end,
  })

  if not ok then
    -- Already registered by a previous call in this session: fine, keep going.
    if not tostring(err):match("already registered") then
      vim.notify("herdr-context provider failed: " .. tostring(err), vim.log.levels.ERROR)
      return false
    end
  end
  registered = true
  return true
end

--- Stage the current review's comments straight into the target agent's prompt,
--- skipping the composer. Unbound by default — the provider is reachable from
--- compose() (<leader>ac) — but kept for :lua require('config.herdr-review').send()
--- or if you want a dedicated key back.
function M.send()
  if not M.register() then
    return
  end
  require("herdr-context.composer").stage_provider(PROVIDER_ID)
end

return M
