-- ESLint LSP — mirrors VSCode ESLint extension behavior:
-- • Validates JS/TS/Vue files (including <template> blocks)
-- • Runs source.fixAll on save (same as editor.codeActionsOnSave)

local dot_country_root = "dot-country-web.client"
local fix_on_save_group = vim.api.nvim_create_augroup("eslint_fix_on_save", { clear = true })
local pending_requests = {}

local function is_dot_country_client(client)
  return client.root_dir ~= nil and vim.fs.basename(client.root_dir) == dot_country_root
end

local function cancel_pending_request(bufnr)
  local pending = pending_requests[bufnr]
  if pending == nil then return end

  pending_requests[bufnr] = nil
  local client = vim.lsp.get_client_by_id(pending.client_id)
  if client and pending.request_id then pcall(client.cancel_request, client, pending.request_id) end
end

local function make_fix_all_params(bufnr)
  return {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
    },
    context = {
      diagnostics = {},
      only = { "source.fixAll.eslint" },
    },
  }
end

local function apply_fix_and_write(client, bufnr, version, actions)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then return end
  if vim.lsp.util.buf_versions[bufnr] ~= version then return end

  local action = vim.iter(actions or {}):find(function(item) return item.edit ~= nil end)
  if action == nil then return end

  vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  if not vim.bo[bufnr].modified or vim.bo[bufnr].readonly or vim.bo[bufnr].buftype ~= "" then return end

  vim.api.nvim_buf_call(bufnr, function()
    local ok, err = pcall(vim.cmd, "silent noautocmd write")
    if not ok then vim.notify("ESLint could not write async fixes: " .. err, vim.log.levels.ERROR) end
  end)
end

local function request_async_fix_all(client, bufnr)
  cancel_pending_request(bufnr)

  local version = vim.lsp.util.buf_versions[bufnr]
  local token = {}
  pending_requests[bufnr] = { client_id = client.id, token = token }

  local ok, request_id = client:request("textDocument/codeAction", make_fix_all_params(bufnr), function(err, actions)
    local pending = pending_requests[bufnr]
    if pending == nil or pending.token ~= token then return end
    pending_requests[bufnr] = nil

    if err then
      vim.notify("ESLint async fix-on-save failed: " .. err.message, vim.log.levels.WARN)
      return
    end

    apply_fix_and_write(client, bufnr, version, actions)
  end, bufnr)

  if not ok then
    pending_requests[bufnr] = nil
    vim.notify("ESLint could not start async fix-on-save", vim.log.levels.WARN)
    return
  end

  pending_requests[bufnr].request_id = request_id
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "eslint" then return end

    cancel_pending_request(args.buf)
    vim.api.nvim_clear_autocmds({ group = fix_on_save_group, buffer = args.buf })

    if is_dot_country_client(client) then
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = fix_on_save_group,
        buffer = args.buf,
        desc = "ESLint: async fix all for dot-country-web.client",
        callback = function(ev) request_async_fix_all(client, ev.buf) end,
      })
    else
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = fix_on_save_group,
        buffer = args.buf,
        desc = "ESLint: fix all before save",
        callback = function(ev)
          client:request_sync("workspace/executeCommand", {
            command = "eslint.applyAllFixes",
            arguments = {
              {
                uri = vim.uri_from_bufnr(ev.buf),
                version = vim.lsp.util.buf_versions[ev.buf],
              },
            },
          }, 3000, ev.buf)
        end,
      })
    end

    vim.api.nvim_create_autocmd({ "BufWipeout", "LspDetach" }, {
      group = fix_on_save_group,
      buffer = args.buf,
      callback = function(ev)
        if ev.event == "BufWipeout" or ev.data.client_id == client.id then cancel_pending_request(ev.buf) end
      end,
    })
  end,
})

return {
  settings = {
    eslint = {
      useFlatConfig = true,
      -- Languages the server should validate (same as eslint.validate in VSCode)
      validate = "probe",
      -- Languages to probe for ESLint config support
      probe = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "vue",
        "markdown",
      },
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine",
        },
        showDocumentation = {
          enable = true,
        },
      },
    },
  },
  -- File types the server should attach to
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
}
