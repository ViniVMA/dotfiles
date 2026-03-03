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

local function has_prettier_config()
  local prettier_files = vim.fs.find({
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
    "prettier.config.ts",
  }, { upward = true, path = vim.fn.getcwd() })
  return #prettier_files > 0
end

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
      format_on_save = function(bufnr)
        local eslint_fts = {
          javascript = true,
          javascriptreact = true,
          typescript = true,
          typescriptreact = true,
          vue = true,
          svelte = true,
        }
        local ft = vim.bo[bufnr].filetype

        -- When ESLint LSP is attached and the project has no Prettier config,
        -- skip conform formatters — ESLint handles formatting via EslintFixAll.
        -- When both ESLint and Prettier exist, let prettierd run (Prettier formats,
        -- ESLint only lints via eslint-config-prettier).
        if eslint_fts[ft] then
          local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })
          if #clients > 0 and not has_prettier_config() then
            return false
          end
        end

        return { timeout_ms = 3000 }
      end,
      formatters_by_ft = {
        javascript = { "biome", "prettierd" },
        typescript = { "biome", "prettierd" },
        javascriptreact = { "biome", "prettierd" },
        typescriptreact = { "biome", "prettierd" },
        vue = { "prettierd" },
        svelte = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "biome", "prettierd" },
        yaml = { "prettierd" },
        markdown = { "biome", "prettierd" },
        graphql = { "prettierd" },
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    }

    return opts
  end,
  config = function(_, opts) require("conform").setup(opts) end,
}
