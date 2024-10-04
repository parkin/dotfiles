{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    ############### lazyvim setup
    ### Base lazyvim
    pkgs.wl-clipboard # for clipboard on wayland
    pkgs.gcc
    pkgs.ripgrep
    pkgs.fd
    pkgs.luarocks
    pkgs.unzip
    pkgs.lazygit
    pkgs.nodejs_22
    pkgs.python3
    pkgs.cargo
    ## for neovim, LSP's, see my setup in (~/.config/nvim/lua/plugins/lsp.lua)
    pkgs.lua-language-server
    pkgs.marksman
    pkgs.nil # nix
    pkgs.pyright
    ## Formatters, see my setup in (~/.config/nvim/lua/plugins/conform.lua)
    pkgs.nixfmt-rfc-style
    pkgs.black
    pkgs.prettierd
    pkgs.markdownlint-cli2
    pkgs.vimPlugins.vim-markdown-toc
    pkgs.stylua
    pkgs.taplo
    ############### /lazyvim setup
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  ## copy the config files
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/parkin/.dotfiles/config/nvim";
      recursive = true;
    };
  };

}
