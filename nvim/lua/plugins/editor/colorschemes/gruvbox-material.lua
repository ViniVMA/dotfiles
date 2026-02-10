return {
  "sainnhe/gruvbox-material",
  -- enabled = false,
  config = function()
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_transparent_background = 1
  end,
  init = function()
    vim.cmd.colorscheme("gruvbox-material")

    -- Make UI plugin backgrounds transparent
    local transparent_groups = {
      -- Bufferline
      "BufferLineFill",
      "BufferLineBackground",
      "BufferLineTab",
      "BufferLineTabClose",
      "BufferLineSeparator",
      "BufferLineOffsetSeparator",
      -- Lualine
      "lualine_c_normal",
      "lualine_c_inactive",
      -- Dropbar
      "DropBarMenuNormalFloat",
      "WinBar",
      "WinBarNC",
    }
    for _, group in ipairs(transparent_groups) do
      vim.api.nvim_set_hl(0, group, { bg = "NONE" })
    end
  end,
}
