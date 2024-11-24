return {
  "neo-tree.nvim",
  opts = {
    window = {
      position = "right",
      width = 50,
    },
    filesystem_watchers = {
      enable = true,
    },
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          -- '.git',
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        never_show = {},
      },
    },
  },
}
