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
  config = function(_, opts)
    require("review").setup(opts)
    -- Upstream close() force-copies all comments to the clipboard. Skip that;
    -- keep the rest of the cleanup. Mirror init.lua:138 if upstream changes.
    require("review").close = function()
      vim.cmd("tabclose")
      require("review.hooks").on_session_closed()
      require("review.storage").clear_revisions()
    end
  end,
}
