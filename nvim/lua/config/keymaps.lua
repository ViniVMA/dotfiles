-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
--
vim.keymap.set(
  "n",
  "<leader>fl",
  '<cmd>lua require("telescope").extensions.flutter.commands()<cr>',
  { desc = "Flutter Tools" }
)

vim.keymap.set("n", "<leader>fg", ":GrugFar<CR>", { desc = "GrugFar" })
vim.keymap.set("n", "<C-j>", "j$", { desc = "Move down and to end of line" })
vim.keymap.set("n", "<C-k>", "k$", { desc = "Move up and to end of line" })
