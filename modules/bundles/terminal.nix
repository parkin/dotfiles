## This file is for configuring the terminal / shell / etc...
{
  pkgs,
  lib,
  config,
  ...
}:
{
  # imports for programs requiring special setup
  imports = [
    # bash
    ../features/bash.nix
    # bat is modern version of cat
    ../features/bat.nix
    # eza setup (modern `ls`)
    ../features/eza.nix
    # fzf setup
    ../features/fzf.nix
    # list files - terminal file manager
    ../features/lf
    # neovim
    ../features/neovim
    # starship module
    ../features/starship
    # tmux
    ../features/tmux
    # yazi terminal file manager
    ../features/yazi
  ];

  options = {
    myHomeManager.bundles.terminal.enable = lib.mkEnableOption "Enables my terminal bundle";
  };

  config = lib.mkIf config.myHomeManager.bundles.terminal.enable {

    # config for my home manager modules
    myHomeManager = {
      bash.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      yazi.enable = true;
    };

    home.packages = with pkgs; [

      # fd, modern find
      fd
      # neofetch is a terminal program to display system info
      neofetch
      # tlrc is the Rust client for tldr (which is npm)
      tlrc
      # ripgrep, modern grep
      ripgrep
      # wget, needed for vscode
      wget

      ## Nerdfonts
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    ## My programs

    programs.git = {
      enable = true;
      # set the git userName and userEmail in the host's home.nix
      # userName = "Will Parkin";
      # userEmail = "wmparkin@gmail.com";
      extraConfig = {
        branch.autosetupmerge = true;
        color.ui = "auto";
        diff.tool = "vimdiff";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    programs.kitty = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

}
