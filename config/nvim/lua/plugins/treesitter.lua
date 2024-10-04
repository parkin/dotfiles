return {
  "nvim-treesitter/nvim-treesitter",
  opts_extend = { "ensure_installed" },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "markdown",
      "markdown_inline",
    },
  },
}
