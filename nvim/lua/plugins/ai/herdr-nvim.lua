-- Herdr's full Neovim sidebar, file picker, and lightweight annotations.
return {
  "ChmaraX/herdr-nvim",
  cond = vim.env.HERDR_ENV == "1",
  opts = {},
  config = function(_, opts)
    require("config.herdr-nvim").setup()
    require("herdr-nvim").setup(opts)
  end,
}
