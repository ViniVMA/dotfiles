-- return {
--   "stevearc/conform.nvim",
--   event = { "BufWritePre" },
--   cmd = { "ConformInfo" },
--   opts = function()
--     local opts = {
--       default_format_opts = {
--         timeout_ms = 3000,
--         async = false,
--         quiet = false,
--         lsp_format = "fallback",
--       },
--       format_on_save = { timeout_ms = 3000 },
--       formatters_by_ft = {
--         javascript = { "biome", "prettierd", "eslint_d" },
--         typescript = { "biome", "prettierd", "eslint_d" },
--         javascriptreact = { "biome", "prettierd", "eslint_d" },
--         typescriptreact = { "biome", "prettierd", "eslint_d" },
--         vue = { "eslint_d", "prettierd" },
--         svelte = { "prettierd", "eslint_d" },
--         css = { "prettierd" },
--         html = { "prettierd" },
--         json = { "biome", "prettierd" },
--         yaml = { "prettierd" },
--         markdown = { "biome", "prettierd" },
--         graphql = { "prettierd" },
--         lua = { "stylua" },
--       },
--       formatters = {
--         injected = { options = { ignore_errors = true } },
--       },
--     }
--     return opts
--   end,
--   config = function(_, opts) require("conform").setup(opts) end,
-- }

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
        vue = { "eslint_d", "prettierd" },
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

    -- Check if we're in the web-core project
    local cwd = vim.fn.getcwd()
    local web_core_path = vim.fn.expand("~/dev/web-core")

    if cwd == web_core_path or vim.startswith(cwd, web_core_path .. "/") then
      -- Override formatters for vue and typescript files in web-core
      opts.formatters_by_ft.vue = { "eslint_d" }
      opts.formatters_by_ft.typescript = { "eslint_d" }
    end

    return opts
  end,
  config = function(_, opts) require("conform").setup(opts) end,
}
