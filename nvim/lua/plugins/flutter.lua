return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
    debugger = {
      enabled = true,
      register_configurations = function(_)
        -- require("dap").configurations.dart = {}
        -- require("dap.ext.vscode").load_launchjs()
      end,
    },
  },
}
