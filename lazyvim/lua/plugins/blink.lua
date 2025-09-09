return {
  "saghen/blink.cmp",

  enabled = true,
  opts = {
    snippets = {
      preset = "luasnip",
    },
    keymap = {
      ["<C-q>"] = {
        function(cmp)
          cmp.show({})
        end,
      },
    },
  },
}
