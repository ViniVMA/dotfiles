-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fg", ":GrugFar<CR>", { desc = "GrugFar" })
vim.keymap.set("n", "<C-j>", "10j", { desc = "Move down and to end of line" })
vim.keymap.set("n", "<C-k>", "10k", { desc = "Move up and to end of line" })

-- Move selected lines with shift+j or shift+k
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Search and replace word under the cursor
vim.keymap.set(
  "n",
  "<F2>",
  [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
  { desc = "Search and replace word under the cursor" }
)

vim.keymap.set("i", "<C-q>", "<cmd>lua require('blink.cmp').show()<CR>")

vim.keymap.set("i", "<C-space>", "<cmd>lua require('blink.cmp').show()<CR>")

-- Show git diff
vim.keymap.set("n", "<leader><leader>v", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end)
