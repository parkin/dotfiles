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
      # molten.nvim settings below
      # whatever other neovim configuration you have
      # plugins = with pkgs.vimPlugins; [
      #   # ... other plugins
      #   image-nvim # for image rendering
      #   molten-nvim
      # ];
      # extraPackages = with pkgs; [
      #   # ... other packages
      #   imagemagick # for image rendering
      # ];
      # extraLuaPackages = ps: [
      #   # ... other lua packages
      #   # magick # for image rendering
      # ];
      # extraPython3Packages =
      #   ps: with ps; [
      #     # ... other python packages
      #     pynvim
      #     jupyter-client
      #     cairosvg # for image rendering
      #     pnglatex # for image rendering
      #     plotly # for image rendering
      #     pyperclip
      #   ];
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
