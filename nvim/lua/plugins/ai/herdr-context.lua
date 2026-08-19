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

    -- The target picker (<leader>at) is already scoped to target_scope = "workspace"
    -- (upstream default), so every candidate shares this project — rendering
    -- workspace/tab/cwd/pane_id is pure noise. terminal_title_stripped (what that
    -- agent is working on) is useful but not enough on its own: it says WHAT, not
    -- WHERE, so two panes in the same split are still hard to map onto what's
    -- actually on screen. `herdr api snapshot` also returns per-pane geometry
    -- (layouts[].panes[].rect) — tag each candidate with where it sits (left/
    -- right/top-left/etc.) by comparing its rect against its siblings in the same
    -- tab layout. No config hook for either the candidate list or the picker, so
    -- patch both in place rather than fork the plugin.
    local targets = require("herdr-context.targets")
    local original_candidates = targets.candidates
    targets.candidates = function(snapshot, opts)
      local candidates = original_candidates(snapshot, opts)
      local layout_by_pane = {}
      for _, layout in ipairs(snapshot.layouts or {}) do
        for _, pane in ipairs(layout.panes or {}) do
          layout_by_pane[pane.pane_id] = { rect = pane.rect, siblings = layout.panes, area = layout.area }
        end
      end
      for _, candidate in ipairs(candidates) do
        local info = layout_by_pane[candidate.pane_id]
        if info and #info.siblings > 1 then
          local xs, ys = {}, {}
          for _, sibling in ipairs(info.siblings) do
            xs[#xs + 1] = sibling.rect.x
            ys[#ys + 1] = sibling.rect.y
          end
          local min_x, max_x = math.min(unpack(xs)), math.max(unpack(xs))
          local min_y, max_y = math.min(unpack(ys)), math.max(unpack(ys))
          local rect, area = info.rect, info.area
          local spans_full_height = area and rect.height >= area.height * 0.9
          local spans_full_width = area and rect.width >= area.width * 0.9
          local parts = {}
          if not spans_full_height and min_y ~= max_y then
            parts[#parts + 1] = rect.y == min_y and "top" or (rect.y == max_y and "bottom" or nil)
          end
          if not spans_full_width and min_x ~= max_x then
            parts[#parts + 1] = rect.x == min_x and "left" or (rect.x == max_x and "right" or nil)
          end
          candidate.position = #parts > 0 and table.concat(parts, "-") or nil
        end
      end
      return candidates
    end

    local picker = require("herdr-context.picker")
    local status_icons = { idle = "●", working = "◉", blocked = "!", unknown = "○" }
    picker.format_item = function(target)
      local status = target.agent_status or "unknown"
      local title = target.terminal_title_stripped or target.terminal_title or ""
      local label = target.position and ("[" .. target.position .. "] " .. title) or title
      return ("%s %-8s %-8s %-8s %s"):format(
        status_icons[status] or "○",
        status,
        target.agent or "agent",
        target.tab_label or target.tab_id or "?",
        label
      )
    end
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
  },
}
