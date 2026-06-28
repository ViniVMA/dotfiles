-- nvim-treesitter `main` branch (master is frozen and unsupported on Neovim 0.12+).
-- main drops the `.configs.setup{ modules }` API: highlight/indent/textobjects are
-- now wired up by hand against the queries Neovim ships with.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false, -- main wires highlighting via a FileType autocmd registered here
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    { "windwp/nvim-ts-autotag" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
  },
  config = function()
    local parsers = {
      "bash", "c", "lua", "markdown", "markdown_inline", "python", "query", "vim", "vimdoc",
      "javascript", "typescript", "tsx", "vue", "html", "css", "scss", "json", "yaml",
      "go", "gomod", "gosum", "gotmpl",
    }
    require("nvim-treesitter").install(parsers) -- no-op for already-installed parsers

    -- Highlight (+ experimental indent) per buffer when a parser is available.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
          -- ponytail: treesitter indent is experimental upstream; was enabled on master.
          -- Drop this line to fall back to built-in indent if it misbehaves.
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Textobjects (main branch): select/move/swap are explicit keymaps now, not a module.
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    for lhs, q in pairs({
      ak = "@block.outer", ik = "@block.inner",
      ac = "@class.outer", ic = "@class.inner",
      ["a?"] = "@conditional.outer", ["i?"] = "@conditional.inner",
      af = "@function.outer", ["if"] = "@function.inner",
      ao = "@loop.outer", io = "@loop.inner",
      aa = "@parameter.outer", ia = "@parameter.inner",
    }) do
      vim.keymap.set({ "x", "o" }, lhs, function() select.select_textobject(q, "textobjects") end, { desc = "select " .. q })
    end

    for fn, maps in pairs({
      goto_next_start = { ["]k"] = "@block.outer", ["]f"] = "@function.outer", ["]a"] = "@parameter.inner" },
      goto_next_end = { ["]K"] = "@block.outer", ["]F"] = "@function.outer", ["]A"] = "@parameter.inner" },
      goto_previous_start = { ["[k"] = "@block.outer", ["[f"] = "@function.outer", ["[a"] = "@parameter.inner" },
      goto_previous_end = { ["[K"] = "@block.outer", ["[F"] = "@function.outer", ["[A"] = "@parameter.inner" },
    }) do
      for lhs, q in pairs(maps) do
        vim.keymap.set({ "n", "x", "o" }, lhs, function() move[fn](q, "textobjects") end, { desc = fn .. " " .. q })
      end
    end

    for lhs, q in pairs({ [">K"] = "@block.outer", [">F"] = "@function.outer", [">A"] = "@parameter.inner" }) do
      vim.keymap.set("n", lhs, function() swap.swap_next(q) end, { desc = "swap next " .. q })
    end
    for lhs, q in pairs({ ["<K"] = "@block.outer", ["<F"] = "@function.outer", ["<A"] = "@parameter.inner" }) do
      vim.keymap.set("n", lhs, function() swap.swap_previous(q) end, { desc = "swap prev " .. q })
    end

    -- Context-aware commentstring (independent of nvim-treesitter modules).
    require("ts_context_commentstring").setup({ enable_autocmd = false })
    local get_option = vim.filetype.get_option
    vim.filetype.get_option = function(filetype, option)
      return option == "commentstring"
          and require("ts_context_commentstring.internal").calculate_commentstring()
        or get_option(filetype, option)
    end

    -- Auto-close/rename HTML/JSX/Vue tags (independent plugin).
    require("nvim-ts-autotag").setup({
      opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false },
      per_filetype = { vue = { enable_close = true } },
    })
  end,
}
