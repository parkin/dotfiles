-- add an AI group to which-key
local wk = require("which-key")
wk.add({
  { "<leader>a", group = "+AI" }, -- group
})

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "anthropic2",
      },
      inline = {
        adapter = "anthropic2",
      },
      cmd = {
        adapter = "anthropic2",
      },
    },
    adapters = {
      anthropic2 = function()
        return require("codecompanion.adapters").extend("anthropic", {
          name = "anthropic2", -- differentiate my extensions
          schema = {
            max_tokens = {
              default = 30000,
            },
          },
        })
      end,
    },
  },
  keys = {
    {
      "<leader>at",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Toggle the AI chat window.",
    },
  },
}
