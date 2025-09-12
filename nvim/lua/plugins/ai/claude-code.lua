return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function() require("claude-code").setup({}) end,
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
    { "<leader>aC", "<cmd>ClaudeCodeContinue<cr>", desc = "Claude Code (Continue)" },
    { "<leader>aR", "<cmd>ClaudeCodeResume<cr>", desc = "Claude Code (Resume)" },
    { "<leader>aV", "<cmd>ClaudeCodeVerbose<cr>", desc = "Claude Code (Verbose)" },
  },
}
