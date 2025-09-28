return {
  "sainnhe/gruvbox-material",
  -- enabled = false,
  config = function() vim.g.gruvbox_material_background = "hard" end,
  init = function() vim.cmd.colorscheme("gruvbox-material") end,
}
