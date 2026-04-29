-- VSCode-style toggle: flips a single rg flag in the running cmd and resumes.
-- Used for Alt+R (regex), Alt+C (match case), Alt+W (whole word).
local function toggle_rg_flag(flag)
  return function(_, opts)
    local utils = require("fzf-lua.utils")
    local o = vim.tbl_deep_extend("keep", {
      cmd = utils.toggle_cmd_flag(assert(opts._cmd or opts.cmd), flag),
      resume = true,
    }, opts.__call_opts or {})
    opts.__call_fn(o)
  end
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    event = "VeryLazy",
    dependencies = {
      "echasnovski/mini.icons",
      opts = {},
    },
    opts = {
      winopts = {
        width = 0.8,
        height = 0.8,
        row = 0.5,
        col = 0.5,
        preview = {
          scrollchars = { "┃", "" },
        },
      },
      oldfiles = {
        include_current_session = true,
      },
      keymap = {
        builtin = {
          ["<esc>"] = "abort",
        },
      },
      file_icons = "mini",
      fzf_colors = true,
      fzf_opts = {
        ["--ansi"] = "",
        ["--info"] = "inline",
        ["--layout"] = "reverse",
      },
      files = {
        prompt = "Files❯ ",
        git_icons = true,
      },
      grep = {
        prompt = "Rg❯ ",
        rg_glob = true, -- enable glob parsing
        glob_flag = "--iglob", -- case insensitive globs
        glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
        -- VSCode-like default: literal text, smart-case. Use Alt+R/C/W to toggle.
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -F -e",
        actions = {
          ["alt-r"] = toggle_rg_flag("-F"), -- toggle regex (removes/adds fixed-strings)
          ["alt-c"] = toggle_rg_flag("-s"), -- toggle Match Case (overrides smart-case)
          ["alt-w"] = toggle_rg_flag("-w"), -- toggle Match Whole Word
        },
      },
      finder = {
        prompt = "LSP Finder> ",
        file_icons = true,
        color_icons = true,
        async = true, -- async by default
        silent = true, -- suppress "not found"
        separator = "| ", -- separator after provider prefix, `false` to disable
        includeDeclaration = true, -- include current declaration in LSP context
        -- by default display all LSP locations
        -- to customize, duplicate table and delete unwanted providers
      },
    },
    config = function() require("fzf-lua").register_ui_select() end,

    keys = {
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true, desc = "FZF Navigate Down" },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true, desc = "FZF Navigate Up" },
      {
        "<leader>,",
        "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      -- Alt+R toggle regex, Alt+C Match Case, Alt+W Whole Word, Ctrl+G fuzzy mode
      { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (literal, alt-r/c/w to toggle)" },
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      -- find
      { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      -- { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
      -- { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      -- { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
      -- { "<leader>fR", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
      -- search
      { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
      -- { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      -- { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
      { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
      { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
      { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
      { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
      { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
      -- { "<leader>sw", LazyVim.pick("grep_cword"), desc = "Word (Root Dir)" },
      -- { "<leader>sW", LazyVim.pick("grep_cword", { root = false }), desc = "Word (cwd)" },
      -- { "<leader>sw", LazyVim.pick("grep_visual"), mode = "v", desc = "Selection (Root Dir)" },
      -- { "<leader>sW", LazyVim.pick("grep_visual", { root = false }), mode = "v", desc = "Selection (cwd)" },
      -- { "<leader>uC", LazyVim.pick("colorschemes"), desc = "Colorscheme with Preview" },
      {
        "<leader>ss",
        function()
          require("fzf-lua").lsp_document_symbols({
            regex_filter = symbols_filter,
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols({
            regex_filter = symbols_filter,
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
    lsp = {
      code_actions = {
        previewer = "codeaction_native",
        preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS",
      },
    },
  },
}
