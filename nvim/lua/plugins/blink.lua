return {
  "saghen/blink.cmp",

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
