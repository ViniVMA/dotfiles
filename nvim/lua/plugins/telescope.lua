return {
  "nvim-telescope/telescope.nvim",
  enabled = false,
  opts = {
    defaults = {
      path_display = { "truncate" },
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },
  config = function()
    require("telescope").load_extension("flutter")
  end,
}
