-- For LazyVim plugins, we usually just pass this to override some default options.
-- To add new formatter, you need to
-- 1. Find formatters here: https://github.com/stevearc/conform.nvim/tree/master
-- 2. Add formatter below
-- 3. Install formatter by adding it to home.nix and switching
-- 4. Enjoy
return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        json = { "jq" },
        kdl = { "kdlfmt" },
        lua = { "stylua" },
        python = { "ruff_format" },
        markdown = { "prettierd" },
        nix = { "nixfmt" },
        rust = { "rustfmt" },
        sql = { "sql_formatter" },
        tex = { "tex-fmt" },
        toml = { "taplo" },
      },
    },
  },
}
