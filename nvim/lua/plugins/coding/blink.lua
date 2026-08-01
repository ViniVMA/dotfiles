return {
  "saghen/blink.cmp",
  dependencies = {
    { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
  },
  version = "1.*",
  lazy = true,
  opts = {
    keymap = {

      -- preset = "enter",
      preset = "super-tab",
      ["<S-Tab>"] = {
        function()
          local ok, neocursor = pcall(require, "neocursor")
          if ok and neocursor.accept() then return true end
        end,
        "snippet_backward",
        "fallback",
      },
      ["<C-y>"] = { "select_and_accept" },
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<C-Space>"] = {
        function(cmp) cmp.show({}) end,
      },
    },

    appearance = {
      nerd_font_variant = "mono",
      use_nvim_cmp_as_default = false,
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        auto_show = false,
        draw = {
          treesitter = { "lsp", "path", "buffer", "snippets" },
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
          },
        },
        direction_priority = function()
          local ctx = require("blink.cmp").get_context()
          local item = require("blink.cmp").get_selected_item()
          if ctx == nil or item == nil then return { "s", "n" } end

          local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
          local is_multi_line = item_text:find("\n") ~= nil

          -- after showing the menu upwards, we want to maintain that direction
          -- until we re-open the menu, so store the context id in a global variable
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { "n", "s" }
          end
          return { "s", "n" }
        end,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    cmdline = {
      enabled = false,
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
