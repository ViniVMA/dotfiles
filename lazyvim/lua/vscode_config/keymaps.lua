local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " " -- Set leader key to Space

-- === File and Window ===
map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>q<CR>", opts)

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- === Buffer Navigation ===
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "[b", ":bprevious<CR>", opts)
map("n", "]b", ":bnext<CR>", opts)

-- === VSCode Commands ===
local function vscode(cmd)
  vim.cmd('call VSCodeNotify("' .. cmd .. '")')
end

map("n", "<leader>bd", function()
  vscode("workbench.action.closeActiveEditor")
end, opts)

map("n", "<leader>ur", function()
  vscode("workbench.action.reloadWindow")
end, opts)
map("n", "<leader>l", function()
  vscode("workbench.view.extensions")
end, opts)
map("n", "<leader>uw", function()
  vscode("editor.action.toggleWordWrap")
end, opts)
map("n", "<leader>ft", function()
  vscode("workbench.action.createTerminalEditor")
end, opts)

-- === LSP / Editor ===
map("n", "gd", function()
  vscode("editor.action.revealDefinition")
end, opts)
map("n", "gr", function()
  vscode("editor.action.goToReferences")
end, opts)
map("n", "gD", function()
  vscode("editor.action.revealDeclaration")
end, opts)
map("n", "gI", function()
  vscode("editor.action.goToImplementation")
end, opts)
map("n", "gy", function()
  vscode("editor.action.goToTypeDefinition")
end, opts)
map("n", "K", function()
  vscode("editor.action.showHover")
end, opts)
map("n", "<C-k>", function()
  vscode("editor.action.triggerParameterHints")
end, opts)
map("n", "[d", function()
  vscode("editor.action.marker.prev")
end, opts)
map("n", "]d", function()
  vscode("editor.action.marker.next")
end, opts)
map("n", "<leader>cf", function()
  vscode("editor.action.formatDocument")
end, opts)
map("n", "<leader>ca", function()
  vscode("editor.action.quickFix")
end, opts)
map("n", "<leader>cr", function()
  vscode("editor.action.rename")
end, opts)

map("i", "<C-q>", function()
  vscode("editor.action.triggerSuggest")
end, opts)

-- === Search / Telescope-like ===
map("n", "<leader>/", function()
  vscode("workbench.action.findInFiles")
end, opts)
map("n", "<leader><space>", function()
  vscode("workbench.action.quickOpen")
end, opts)
map("n", "<leader>fb", function()
  vscode("workbench.action.quickOpen")
end, opts)
map("n", "<leader>ff", function()
  vscode("workbench.action.quickOpen")
end, opts)

-- === Git ===
map("n", "<leader>gg", function()
  vscode("workbench.view.scm")
end, opts)
map("n", "<leader>gc", function()
  vscode("workbench.view.scm")
end, opts)
map("n", "<leader>gs", function()
  vscode("workbench.view.scm")
end, opts)

-- === Diagnostics ===
map("n", "<leader>cd", function()
  vscode("editor.action.showHover")
end, opts)
map("n", "<leader>cl", function()
  vscode("workbench.action.output.toggleOutput")
end, opts)
map("n", "<leader>sd", function()
  vscode("workbench.actions.view.problems")
end, opts)
map("n", "<leader>sD", function()
  vscode("workbench.actions.view.problems")
end, opts)

-- === File / Explorer ===
map("n", "<leader>fe", function()
  vscode("workbench.files.action.showActiveFileInExplorer")
end, opts)
map("n", "<leader>fE", function()
  vscode("workbench.explorer.fileView.toggleVisibility")
end, opts)

map("n", "<leader>e", function()
  vscode("workbench.action.toggleSidebarVisibility")
end, opts)

-- map("n", "<leader>e", function()
--   vscode("workbench.view.explorer")
-- end, opts)

-- map("n", "<leader>e", function()
--   vscode("workbench.files.action.showActiveFileInExplorer")
-- end, opts)
map("n", "<leader>E", function()
  vscode("workbench.explorer.fileView.toggleVisibility")
end, opts)

-- === Move Lines ===
map("n", "<A-j>", function()
  vscode("editor.action.moveLinesDownAction")
end, opts)
map("n", "<A-k>", function()
  vscode("editor.action.moveLinesUpAction")
end, opts)

-- === Spectre-like (Replace in Files) ===
map("n", "<leader>sr", function()
  vscode("editor.action.startFindReplaceAction")
end, opts)

-- === Reload VSCode Theme ===
map("n", "<leader>uC", function()
  vscode("workbench.action.selectTheme")
end, opts)

-- === Others: Buffers, Quick Open, Recent Files ===
map("n", "<leader>fr", function()
  vscode("workbench.action.quickOpen")
end, opts)
map("n", "<leader>fR", function()
  vscode("workbench.action.quickOpen")
end, opts)

-- === Command Palette ===
map("n", "<leader>sC", function()
  vscode("workbench.action.showCommands")
end, opts)
map("n", "<leader>sk", function()
  vscode("workbench.action.showCommands")
end, opts)

-- === Visual Mode Indent Keep Selection ===
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
