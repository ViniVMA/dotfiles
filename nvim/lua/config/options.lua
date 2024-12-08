vim.opt.shell = "nu"
vim.opt.shell = "nu"
vim.opt.shellcmdflag = "-c"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

vim.opt.winbar = "%=%m %f"

vim.o.ignorecase = true
vim.o.smartcase = true

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})
