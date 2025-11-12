return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      diagnostics = {
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = {},
      },
      codelens = {
        enabled = false,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        ts_ls = {
          enabled = false,
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local lsp_keymaps = require("plugins.lsp.keymaps")
      local lsp_utils = {}

      -- Helper: load server-specific options from servers/*.lua
      function lsp_utils.load_server_opts(server)
        local ok, config = pcall(require, "plugins.lsp.servers." .. server)
        if ok and type(config) == "table" then return config end
        return {}
      end

      function lsp_utils.on_attach(client, buffer)
        lsp_keymaps.on_attach(client, buffer)

        -- Add semantic tokens error prevention
        if client.server_capabilities and client.server_capabilities.semanticTokensProvider == nil then
          -- Create a dummy semantic tokens provider to prevent nil access errors
          client.server_capabilities.semanticTokensProvider = false
        end

        if opts.inlay_hints.enabled and vim.lsp.inlay_hint then
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end

        if opts.codelens.enabled and vim.lsp.codelens and client.supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Add global semantic tokens error prevention
      local original_buf_request = vim.lsp.buf_request
      vim.lsp.buf_request = function(bufnr, method, params, handler, config)
        -- Intercept semantic tokens requests and handle nil semanticTokensProvider
        if method == "textDocument/semanticTokens/full" or method == "textDocument/semanticTokens/range" then
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          local has_semantic_support = false
          for _, client in ipairs(clients) do
            if client.server_capabilities and client.server_capabilities.semanticTokensProvider then
              has_semantic_support = true
              break
            end
          end

          if not has_semantic_support then
            -- Skip this request if no client supports semantic tokens
            if handler then
              handler(nil, { code = -32601, message = "Method not found" }, { method = method })
            end
            return
          end
        end
        return original_buf_request(bufnr, method, params, handler, config)
      end

      -- Add additional protection for the semantic tokens module
      local ok, semantic = pcall(require, "vim.lsp.semantic_tokens")
      if ok and semantic.send_request then
        local original_send_request = semantic.send_request
        semantic.send_request = function(bufnr, client_id, method, options)
          local client = vim.lsp.get_client_by_id(client_id)
          if not client or not client.server_capabilities or not client.server_capabilities.semanticTokensProvider then
            return
          end
          return original_send_request(bufnr, client_id, method, options)
        end
      end

      local servers = vim.tbl_deep_extend("force", {}, opts.servers)

      -- Merge in all local server files from plugins/lsp/servers
      local server_files = vim.fn.globpath(vim.fn.stdpath("config") .. "/lua/plugins/lsp/servers", "*.lua", false, true)
      for _, path in ipairs(server_files) do
        local server_name = path:match(".*/([%w_]+)%.lua$")
        if server_name then
          local ok, server_opts = pcall(require, "plugins.lsp.servers." .. server_name)
          if ok and type(server_opts) == "table" then
            servers[server_name] = vim.tbl_deep_extend("force", servers[server_name] or {}, server_opts)
          end
        end
      end

      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      -- 🚨 replacement for `require("lspconfig")[server].setup{}`:
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
          on_attach = lsp_utils.on_attach,
        }, servers[server] or {})

        if server_opts.enabled == false then return end

        -- define config
        vim.lsp.config(server, server_opts)

        -- enable the server
        vim.lsp.enable(server)
      end

      -- handle Mason integration
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings").get_all().lspconfig_to_package)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false and vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      vim.api.nvim_set_hl(0, "@lsp.type.component", { link = "@type" })

      if have_mason then
        mlsp.setup({
          ensure_installed = ensure_installed,
          handlers = { setup },
        })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "selene",
        "shfmt",
        "biome",
        "eslint_d",
        "prettierd",
        "eslint-lsp",
        "css-lsp",
        "html-lsp",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(
          function()
            require("lazy.core.handler.event").trigger({
              event = "FileType",
              buf = vim.api.nvim_get_current_buf(),
            })
          end,
          100
        )
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end)
    end,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function() require("tiny-inline-diagnostic").setup() end,
  },
}
