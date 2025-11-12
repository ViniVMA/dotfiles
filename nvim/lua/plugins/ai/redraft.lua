return {
  "jim-at-jibba/nvim-redraft",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
  },
  event = "VeryLazy",
  build = "cd ts && npm install && npm run build",
  opts = {
    llm = {
      provider = "copilot",
      model = "gpt-4o", -- or "gpt-4-turbo"
    },
  },
}
