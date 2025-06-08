return {
  "nvim-treesitter/nvim-treesitter",
  opts_extend = { "ensure_installed" },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "go",
      "just",
      "kdl",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "ron", -- for rust object notation
      "ruby",
      "rust",
      "sql",
      "toml",
      "typescript",
    },
  },
}
