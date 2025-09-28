return {
  "eldritch-theme/eldritch.nvim",
  enabled = false,
  lazy = false,
  priority = 1000,
  opts = {},
  init = function() vim.cmd.colorscheme("eldritch") end,
}
