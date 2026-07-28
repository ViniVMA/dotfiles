-- herdr-context.nvim — stage code, symbols, hunks and diagnostics into the prompt
-- of an agent already running in a herdr pane, without submitting.
--
-- Replaces sidekick.nvim (disabled in sidekick.lua). Different model: sidekick
-- owned a terminal inside nvim, so its keys were about toggling and focusing that
-- window. herdr owns the panes, so navigation is C-a h/j/k/l and these keys only
-- decide *what context goes where*.
--
-- Keys are upstream's defaults, with ONE forced exception: the README suggests
-- <leader>ar for refresh(), which is `Review` in plugins/editor/review.lua. Refresh
-- stays unbound — use :HerdrContextRefresh.
--
-- Options are upstream's defaults apart from focus_after_send.
--
-- Commands beyond these keys: :HerdrContextSymbol, :HerdrContextHunk,
-- :HerdrContextQuickfix, :HerdrContextLocationList, :HerdrContextHistory.
return {
  "makyinmars/herdr-context.nvim",
  -- No-op outside a herdr pane rather than erroring on every keypress. Note this
  -- means the plugin does not load in a plain kitty tab (Cmd+T).
  cond = vim.env.HERDR_ENV == "1",
  lazy = false,
  opts = {
    -- Land in the agent's pane after staging, instead of staying in nvim and
    -- having to navigate over with C-a h/j/k/l to press enter. Runs
    -- `herdr agent focus <pane>` as the last step of the send.
    --
    -- Side effect worth knowing: a focus command marks the agent as *seen*, so
    -- this flips it out of `done` in the sidebar. CLI reads do not. If you use
    -- `done` to track which agents still need review, that signal goes away for
    -- any agent you send to.
    --
    -- submit stays false (upstream default): the context is staged into the
    -- agent's prompt and you press enter yourself, now without moving first.
    focus_after_send = true,
  },
  config = function(_, opts)
    require("herdr-context").setup(opts)
    -- Make review.nvim's comments a first-class context source, so they can be
    -- toggled inside compose() alongside selection/hunk/diagnostics. This is why
    -- <leader>as is not needed any more: review.nvim's own export.to_sidekick()
    -- is hard-wired to sidekick and dies with it disabled.
    require("config.herdr-review").register()
  end,
  keys = {
    {
      "<leader>ac",
      function() require("herdr-context").compose() end,
      mode = { "n", "v" },
      desc = "Compose Herdr Context",
    },
    {
      "<leader>ap",
      function() require("herdr-context").prompt() end,
      mode = { "n", "v" },
      desc = "Prompt Herdr with Code Context",
    },
    {
      "<leader>ay",
      function() require("herdr-context").reference() end,
      mode = { "n", "v" },
      desc = "Send Reference to Herdr Agent",
    },
    {
      "<leader>aY",
      function() require("herdr-context").send() end,
      mode = { "n", "v" },
      desc = "Send Context to Herdr Agent",
    },
    {
      "<leader>ad",
      function() require("herdr-context").diagnostics() end,
      mode = { "n", "v" },
      desc = "Send Diagnostics to Herdr Agent",
    },
    {
      "<leader>at",
      function() require("herdr-context").select_target() end,
      desc = "Select Herdr Agent",
    },
    {
      "<leader>aa",
      function() require("herdr-context").agents() end,
      desc = "Toggle Herdr Agents",
    },
  },
}
