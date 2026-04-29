return {
  "georgeguimaraes/review.nvim",
  version = "v*",
  dependencies = {
    "esmuellert/codediff.nvim",
    "MunifTanjim/nui.nvim",
  },
  cmd = { "Review" },
  keys = {
    { "<leader>ar", "<cmd>Review<cr>", desc = "Review" },
    { "<leader>aR", "<cmd>Review commits<cr>", desc = "Review commits" },
  },
  opts = {},
}
