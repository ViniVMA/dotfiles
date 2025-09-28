return {
  "wtfox/jellybeans.nvim",
  enabled = false,
  lazy = false,
  priority = 1000,
  opts = {}, -- Optional
  init = function()
    -- vim.cmd.colorscheme("jellybeans")
    vim.cmd.colorscheme("jellybeans-mono")
  end,
}
