return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "joechrisellis/lsp-format-modifications.nvim",
  },
  opts = {
    servers = {
      azure_pipelines_ls = {
        cmd = { "azure-pipelines-language-server", "--stdio" },
        filetypes = { "yaml" },
        root_dir = require("lspconfig.util").root_pattern("azure-pipelines.yml"),
        single_file_support = true,
        settings = {},
        -- Add on_attach directly to the server config
        on_attach = function(client, bufnr)
          local lsp_format_modifications = require("lsp-format-modifications")

          -- Format modifications on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              if client.server_capabilities.documentRangeFormattingProvider then
                lsp_format_modifications.format_modifications(client, bufnr)
              end
            end,
            desc = "Format modifications on save",
          })
        end,
      },
    },
  },
}
