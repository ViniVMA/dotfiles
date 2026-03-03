-- ESLint LSP — mirrors VSCode ESLint extension behavior:
-- • Validates JS/TS/Vue files (including <template> blocks)
-- • Runs source.fixAll on save (same as editor.codeActionsOnSave)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "eslint" then
      return
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
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
