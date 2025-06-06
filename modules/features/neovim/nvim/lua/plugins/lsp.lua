-- LSP configuration
-- Note that since I'm using Nix, I have Mason disabled, so I need to have the LSP's added to my home-manager home.nix.
-- 1. add the nix lsp package to ~/.config/home-manager/home.nix
-- 2. add a line to this file
--

local dotfiles = "/home/parkin/.dotfiles"

return {
  -- {
  --   "microsoft/python-type-stubs",
  -- },
  {
    "neovim/nvim-lspconfig",
    -- dependencies = { "microsoft/python-type-stubs" },
    opts = {
      servers = {
        -- rust
        bacon_ls = {
          enabled = diagnostics == "bacon-ls",
        },
        -- python
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                -- pandas-stubs only supports pyright basic typeCheckingMode
                -- https://github.com/pandas-dev/pandas-stubs/issues/963#issuecomment-2248294958
                -- typeCheckingMode = "basic",
                -- autoSearchPaths = true,
                -- autoImportCompletions = true,
                -- turn off the library code analysis, was making things slow
                -- you can generate stubs with `basedpyright --createstub <import>`
                useLibraryCodeForTypes = false,
                diagnosticMode = "workspace",
                -- logLevel = "Trace",
                -- stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
              },
            },
          },
        },
        bashls = {},
        gopls = { gofumpt = true },
        jsonls = {},
        lua_ls = {},
        -- marksman = {},
        -- nil_ls = {},
        nixd = {
          cmd = { "nixd" },
          settings = {
            nixd = {
              nixpkgs = {
                -- expr = "import <nixpkgs> { }",
                expr = 'import (builtins.getFlake "' .. dotfiles .. '").inputs.nixpkgs { }',
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "' .. dotfiles .. '").nixosConfigurations."galacticboi-nixos".options',
                },
                home_manager = {
                  expr = '(builtins.getFlake  "'
                    .. dotfiles
                    .. '").homeConfigurations."parkin@galacticboi-nixos".options',
                  -- expr = '(builtins.getFlake  "/home/parkin/.dotfiles").homeConfigurations."parkin@wsl-nixos".options',
                },
              },
            },
          },
        },
        -- rust - disable so rustacean can handle this
        rust_analyzer = { enabled = false },
        -- ruby
        solargraph = {},
        -- sql
        sqls = {},
        -- toml
        taplo = {},
        -- latex
        texlab = {},
        -- typescript-language-server
        ts_ls = {},
      },
    },
  },
  -- add paths to my extra language directories here
  { import = "plugins.lang.markdown" },
}
