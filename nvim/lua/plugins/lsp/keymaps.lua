local M = {}

M._keys = nil

function M.get()
  if M._keys then return M._keys end

  M._keys = {
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
    { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
    {
      "<c-k>",
      function() return vim.lsp.buf.signature_help() end,
      mode = "i",
      desc = "Signature Help",
      has = "signatureHelp",
    },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
    { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
    { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
    { "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format Document" },
    {
      "<leader>cd",
      function()
        require("fzf-lua").diagnostics_document({
          severity = "warn|error",
          opts = { height = 0.4, prompt = "Diagnostics> " },
          mode = "location",
        })
      end,
      desc = "Show Diagnostics on FZF",
    },
  }

  return M._keys
end

function M.has_capability(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has_capability(buffer, m) then return true end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method, buffer) then return true end
  end
  return false
end

function M.on_attach(client, buffer)
  local keymaps = M.get()

  for _, keymap in pairs(keymaps) do
    local has = not keymap.has or M.has_capability(buffer, keymap.has)
    local cond = not (keymap.cond == false or ((type(keymap.cond) == "function") and not keymap.cond()))

    if has and cond then
      local opts = {
        desc = keymap.desc,
        nowait = keymap.nowait,
        silent = keymap.silent ~= false,
        buffer = buffer,
      }
      vim.keymap.set(keymap.mode or "n", keymap[1], keymap[2], opts)
    end
  end

  -- Handle semantic tokens for Vue files more safely
  if vim.bo[buffer].filetype == "vue" then
    -- Disable vtsls/tsserver semantic tokens inside Vue files
    if (client.name == "vtsls" or client.name == "tsserver") then
      if client.server_capabilities then
        client.server_capabilities.semanticTokensProvider = nil
        -- Also disable in the client config to prevent future requests
        if client.config and client.config.capabilities then
          client.config.capabilities.textDocument = client.config.capabilities.textDocument or {}
          client.config.capabilities.textDocument.semanticTokens = nil
        end
      end
    end

    -- explicitly enable full semantic tokens for vue_ls
    if client.name == "vue_ls" and client.server_capabilities and client.server_capabilities.semanticTokensProvider then
      -- Ensure semanticTokensProvider is a table before setting properties
      if type(client.server_capabilities.semanticTokensProvider) == "table" then
        client.server_capabilities.semanticTokensProvider.full = true
      end
    end
  end

  if client.supports_method("textDocument/inlayHint") then
    vim.keymap.set(
      "n",
      "<leader>th",
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
      { buffer = buffer, desc = "Toggle Inlay Hints" }
    )
  end
end

return M
