return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<S-Tab>",
        accept_word = "<M-l>",
        accept_line = "<M-S-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
  init = function()
    local notified = false
    local original_notify = vim.notify
    vim.notify = function(msg, ...)
      if type(msg) == "string" and msg:match("%[Copilot%.lua%]") then
        if not notified then
          notified = true
          return original_notify(msg, ...)
        end
        return
      end
      return original_notify(msg, ...)
    end
  end,
}
