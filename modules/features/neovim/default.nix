{
  config,
  pkgs,
  nixos-unstable,
  lib,
  ...
}:
{
  options = {
    myHomeManager.neovim.enable = lib.mkEnableOption "Enable neovim";
  };
  config = lib.mkIf config.myHomeManager.neovim.enable {

    home.packages = with pkgs; [
      ############### lazyvim setup
      ### Base lazyvim
      wl-clipboard # for clipboard on wayland
      gcc
      ripgrep
      fd
      unzip
      lazygit
      nodejs_latest
      python3
      tree-sitter
      # freezing at lua5.1, although I'm not sure why
      lua5_1
      lua51Packages.luarocks
      # cargo
      ###### for neovim, LSP's, see my setup in (~/.config/nvim/lua/plugins/lsp.lua)
      bash-language-server
      lua-language-server
      gopls
      marksman
      typescript-language-server
      nixd # nix
      basedpyright
      texlab
      vscode-langservers-extracted # html/css/json/eslint language servers
      rust-analyzer
      solargraph
      sqls
      ###### Formatters, see my setup in (~/.config/nvim/lua/plugins/conform.lua)
      nixos-unstable.kdlfmt
      jq # json
      nixfmt-rfc-style
      gofumpt
      ruff
      prettierd
      markdownlint-cli2
      vimPlugins.vim-markdown-toc
      rustfmt
      shfmt # bash
      stylua
      sql-formatter
      taplo
      tex-fmt
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
        source = config.lib.file.mkOutOfStoreSymlink "${config.mynixos.dotfilesPath}/modules/features/neovim/nvim";
        recursive = true;
      };
    };

  };

}
