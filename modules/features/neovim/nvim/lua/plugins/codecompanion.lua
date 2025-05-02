-- don't load on my wsl
if vim.fn.hostname() == "wsl-nixos" then
  return {}
end

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  -- TODO: Needs more setup
  opts = {
    strategies = {
      chat = {
        adapter = "anthropic",
      },
    },
  },
}
