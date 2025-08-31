return {
  "hrsh7th/nvim-cmp",
  enabled = false,
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
      -- ["<C-q>"] = cmp.mapping.complete(),
      ["<C-Space>"] = cmp.mapping.complete(),
    })
  end,
}
