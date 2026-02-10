return {
  "Bekaboo/dropbar.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>;", function() require("dropbar.api").pick() end, desc = "Dropbar Pick" },
    { "[;", function() require("dropbar.api").goto_context_start() end, desc = "Dropbar Goto Context Start" },
    { "];", function() require("dropbar.api").select_next_context() end, desc = "Dropbar Select Next Context" },
  },
  opts = {
    bar = {
      sources = function(buf, _)
        local sources = require("dropbar.sources")
        if vim.bo[buf].buftype == "terminal" then
          return { sources.terminal }
        end
        return { sources.path }
      end,
    },
  },
}
