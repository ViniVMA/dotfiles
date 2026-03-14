return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    cli = {
      tools = {
        claude = {
          cmd = { "claude", "--allow-dangerously-skip-permissions" },
        },
      },
      prompts = {
        -- Refactoring & cleanup
        simplify = "Simplify {this}. Reduce complexity, remove unnecessary abstractions, and make it more readable.",
        extract = "Extract reusable logic from {this} into well-named functions.",
        modernize = "Refactor {this} to use modern JavaScript/TypeScript idioms and best practices.",
        naming = "Suggest better names for the variables, functions, and types in {this}. Explain your reasoning.",

        -- Writing & implementation
        implement = "Implement {this}. Follow existing patterns in the codebase.",
        errors = "Add proper error handling to {this}. Use appropriate error types and messages.",
        types = "Add or improve TypeScript types for {this}. Prefer strict types over 'any'. Use existing type definitions where possible.",

        -- Debugging & quality
        debug = "Help me debug {this}. Trace the logic, identify potential issues, and suggest fixes.",
        security = "Review {file} for security vulnerabilities. Check for injection, auth issues, data exposure, and OWASP top 10 concerns.",
        perf = "Analyze {this} for performance issues. Identify bottlenecks, unnecessary computations, and suggest improvements.",
        readable = "Rewrite {this} to be more readable. Prioritize clarity over cleverness.",

        -- TypeScript-specific
        tserror = "Explain this TypeScript error and fix it:\n{diagnostics}",
        enum = "Convert {this} from a TypeScript enum to an `as const` object pattern with a matching type alias.",
      },
      mux = {
        backend = "zellij",
        enabled = true,
      },
      win = {
        wo = {
          winhighlight = "Normal:Normal,NormalNC:Normal,EndOfBuffer:Normal,SignColumn:Normal",
        },
        split = {
          height = 0.40,
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
      "<c-\\>",
      function() require("sidekick.cli").toggle() end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Toggle",
    },
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "Sidekick Claude Toggle",
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
      function() require("sidekick.cli").toggle({ focus = true }) end,
      desc = "Sidekick Toggle CLI",
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
