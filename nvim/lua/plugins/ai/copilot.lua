return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<S-Tab>",
        accept_word = "<M-l>",
        accept_line = "<M-S-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
