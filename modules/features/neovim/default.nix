{
  config,
  pkgs,
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
      luarocks
      unzip
      lazygit
      nodejs_22
      python3
      cargo
      ## for neovim, LSP's, see my setup in (~/.config/nvim/lua/plugins/lsp.lua)
      lua-language-server
      marksman
      typescript-language-server
      nixd # nix
      basedpyright
      vscode-langservers-extracted # html/css/json/eslint language servers
      solargraph
      ## Formatters, see my setup in (~/.config/nvim/lua/plugins/conform.lua)
      nixfmt-rfc-style
      ruff
      prettierd
      markdownlint-cli2
      vimPlugins.vim-markdown-toc
      stylua
      taplo
      ############### /lazyvim setup
    ];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      # molten.nvim settings below
      # whatever other neovim configuration you have
      plugins = with pkgs.vimPlugins; [
        # ... other plugins
        image-nvim # for image rendering
        molten-nvim
      ];
      extraPackages = with pkgs; [
        # ... other packages
        imagemagick # for image rendering
      ];
      extraLuaPackages = ps: [
        # ... other lua packages
        # magick # for image rendering
      ];
      extraPython3Packages =
        ps: with ps; [
          # ... other python packages
          pynvim
          jupyter-client
          cairosvg # for image rendering
          pnglatex # for image rendering
          plotly # for image rendering
          pyperclip
        ];
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    ## copy the config files
    xdg.configFile = {
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.myHomeManager.dotfilesPath}/modules/features/neovim/nvim";
        recursive = true;
      };
    };

  };

}
