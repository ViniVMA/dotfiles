return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      azure_pipelines_ls = {
        cmd = { "azure-pipelines-language-server", "--stdio" },
        filetypes = { "yaml" },
        root_dir = require("lspconfig.util").root_pattern("azure-pipelines.yml"),
        single_file_support = true,
        settings = {},
      },
      vtsls = {
        settings = {
          javascript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
          typescript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
          },
        },
      },
    },
  },
}
