-- disable this plugin by returning {}
if true then
  return {}
end

return {
  "lmburns/lf.nvim",
  cmd = "Lf",
  dependencies = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
  opts = {
    winblend = 0,
    highlights = { NormalFloat = { guibg = "NONE" } },
    border = "single",
    escape_quit = true,
  },
  keys = {
    { "<leader>flf", "<cmd>Lf<cr>", desc = "LF File Manager" },
  },
}
