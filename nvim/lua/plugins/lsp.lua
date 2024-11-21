return {
  "neovim/nvim-lspconfig",
  opts = function()
    require("lspconfig").dartls.setup({
      cmd = { "dart", "language-server", "--protocol=lsp" },
    })
  end,
}
