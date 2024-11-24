return {
  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
      ["<C-q>"] = cmp.mapping.complete(), -- Trigger completion
    })
  end,
}
