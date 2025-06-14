-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.vscode then
  require("vscode_config.keymaps")
end
require("config.lazy")
