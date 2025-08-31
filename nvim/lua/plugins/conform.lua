-- return {
--   "stevearc/conform.nvim",
--   dependencies = {
--     "lewis6991/gitsigns.nvim",
--   },
--   opts = function(_, opts)
--     -- Define the format_hunks function
--     local function format_hunks()
--       local ignore_filetypes = { "lua" }
--       if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
--         vim.notify("range formatting for " .. vim.bo.filetype .. " not working properly.")
--         return
--       end
--
--       local hunks = require("gitsigns").get_hunks()
--       if hunks == nil then
--         return
--       end
--
--       local format = require("conform").format
--
--       local function format_range()
--         if next(hunks) == nil then
--           vim.notify("done formatting git hunks", "info", { title = "formatting" })
--           return
--         end
--         local hunk = nil
--         while next(hunks) ~= nil and (hunk == nil or hunk.type == "delete") do
--           hunk = table.remove(hunks)
--         end
--
--         if hunk ~= nil and hunk.type ~= "delete" then
--           local start = hunk.added.start
--           local last = start + hunk.added.count
--           local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
--           local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
--           format({ range = range, async = true, lsp_fallback = true }, function()
--             vim.defer_fn(function()
--               format_range()
--             end, 1)
--           end)
--         end
--       end
--
--       format_range()
--     end
--
--     -- Don't set opts.format_on_save directly
--     -- Instead, return the function directly
--     return vim.tbl_deep_extend("force", opts or {}, {
--       format_on_save = format_hunks,
--     })
--   end,
-- }
--
--
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = function()
    local opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      format_on_save = { timeout_ms = 3000 },
      formatters_by_ft = {
        javascript = { "biome", "prettierd", "eslint_d" },
        typescript = { "biome", "prettierd", "eslint_d" },
        javascriptreact = { "biome", "prettierd", "eslint_d" },
        typescriptreact = { "biome", "prettierd", "eslint_d" },
        vue = { "prettierd", "eslint_d" },
        svelte = { "prettierd", "eslint_d" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "biome", "prettierd" },
        yaml = { "prettierd" },
        markdown = { "biome", "prettierd" },
        graphql = { "prettierd" },
        lua = { "stylua" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    }
    return opts
  end,
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
