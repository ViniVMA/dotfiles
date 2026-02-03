return {
  "oskarnurm/koda.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- require("koda").setup({ transparent = true })
    vim.cmd("colorscheme koda")
  end,
}
