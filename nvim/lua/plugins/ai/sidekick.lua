return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = "zellij",
        enabled = false,
      },
      win = {
        layout = "float",
        wo = {
          winbar = " %{mode() ==# 't' ? ' TERMINAL' : ' NORMAL'}",
        },
        float = {
          width = 0.8,
          height = 0.8,
          border = "rounded",
        },
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function() require("sidekick.cli").focus() end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Switch Focus",
    },
    {
      "<leader>aa",
      function()
        local Config = require("sidekick.config")
        local Terminal = require("sidekick.cli.terminal")
        Config.cli.win.layout = "float"
        for _, term in ipairs(Terminal.sessions()) do
          if term.opts and term:is_open() and term.opts.layout ~= "float" then
            term:hide()
          end
          if term.opts then term.opts.layout = "float" end
        end
        require("sidekick.cli").toggle({ focus = true })
      end,
      desc = "Sidekick Toggle CLI (Float)",
      mode = { "n", "v" },
    },
    {
      "<leader>as",
      function()
        local Config = require("sidekick.config")
        local Terminal = require("sidekick.cli.terminal")
        Config.cli.win.layout = "right"
        for _, term in ipairs(Terminal.sessions()) do
          if term.opts and term:is_open() and term.opts.layout ~= "right" then
            term:hide()
          end
          if term.opts then term.opts.layout = "right" end
        end
        require("sidekick.cli").toggle({ focus = true })
      end,
      desc = "Sidekick Toggle CLI (Split)",
      mode = { "n", "v" },
    },
    {
      "<c-q>",
      function() require("sidekick.cli").toggle() end,
      mode = { "t" },
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "Sidekick Claude Toggle",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      desc = "Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
  },
}
