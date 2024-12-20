return {
  "nvim-treesitter/nvim-treesitter",
  opts_extend = { "ensure_installed" },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "just",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "ruby",
      "sql",
      "toml",
      "typescript",
    },
  },
}
