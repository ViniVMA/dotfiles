return {
  "scottmckendry/cyberdream.nvim",
  -- enabled = false,
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    overrides = function(colors)
      local diagnostic_error = { undercurl = true, sp = colors.red }

      -- Herdr advertises xterm-256color, which cannot render a colored
      -- undercurl. Keep errors visible when Neovim falls back to an underline.
      if vim.env.HERDR_ENV == "1" then diagnostic_error.fg = colors.red end

      return {
        DiagnosticUnderlineError = diagnostic_error,
      }
    end,
  },
  init = function() vim.cmd("colorscheme cyberdream") end,
}
