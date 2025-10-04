return {
  "L3MON4D3/LuaSnip",
  opts = function(_, opts)
    local luasnip = require("luasnip")
    luasnip.filetype_extend("dart", { "flutter" })

    return opts
  end,
}
