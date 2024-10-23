-- LSP configuration
-- Note that since I'm using Nix, I have Mason disabled, so I need to have the LSP's added to my home-manager home.nix.
-- 1. add the nix lsp package to ~/.config/home-manager/home.nix
-- 2. add a line to this file

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {},
        -- marksman = {},
        -- nil_ls = {},
        nixd = {
          cmd = { "nixd" },
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/home/parkin/.dotfiles").nixosConfigurations."galacticboi-nixos".options',
                },
                home_manager = {
                  expr = '(builtins.getFlake  "/home/parkin/.dotfiles").homeConfigurations."parkin@galacticboi-nixos".options',
                  -- expr = '(builtins.getFlake  "/home/parkin/.dotfiles").homeConfigurations."parkin@wsl-nixos".options',
                },
              },
            },
          },
        },
        pyright = {},
      },
    },
  },
  -- add paths to my extra language directories here
  { import = "plugins.lang.markdown" },
}
