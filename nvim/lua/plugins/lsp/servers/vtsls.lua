return {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "javascript.jsx",
    "typescript.tsx",
    "vue",
  },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {},
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      -- ponytail: stops tsserver scanning every node_modules/package.json for
      -- auto-imports — that scan is what pegs vtsls at 200%+ CPU on big repos.
      -- Cost: no import suggestions for not-yet-imported packages. Set "auto" to restore.
      preferences = {
        includePackageJsonAutoImports = "off",
      },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      preferences = {
        includePackageJsonAutoImports = "off",
      },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
  before_init = function(_, config)
    local ok, registry = pcall(require, "mason-registry")
    if not ok then
      return
    end

    if registry.is_installed("vue-language-server") then
      local vue_plugin_config = {
        name = "@vue/typescript-plugin",
        location = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server"),
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      }

      local plugins = config.settings.vtsls.tsserver.globalPlugins
      local exists = false
      for _, plugin in ipairs(plugins) do
        if plugin.name == vue_plugin_config.name then
          exists = true
          break
        end
      end
      if not exists then
        table.insert(plugins, vue_plugin_config)
      end
    end
  end,
}
