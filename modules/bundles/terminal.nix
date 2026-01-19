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
    ../features
  ];

  options = {
    myHomeManager = {
      bundles.terminal.enable = lib.mkEnableOption "Enables my terminal bundle";
      terminal.shellAliases = lib.mkOption {
        type = lib.types.anything;
        description = "shellAliases to pass to bash and zsh";
        default = { };
        example = {
          cd = "..";
          ll = "ls -l";
        };
      };
    };
  };

  config = lib.mkIf config.myHomeManager.bundles.terminal.enable {

    # config for my home manager modules
    myHomeManager = {
      bash.enable = true;
      bat.enable = true;
      eza.enable = true;
      fzf.enable = true;
      neovim.enable = true;
      starship.enable = true;
      tmux.enable = true;
      yazi.enable = true;
      zellij.enable = true;
      zsh.enable = true;

      terminal.shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "~" = "cd ~";
        cddot = "cd ${config.mynixos.dotfilesPath}";
        # Reload the shell (i.e. invoke as a login shell)
        reload = "exec $SHELL -l";
        # Print each PATH entry on a separate line
        path = "echo -e \${PATH//:/\\n}";
        # Git stuff
        ga = "git add";
        gc = "git commit";
        gcm = "git commit -m";
        gs = "git status";
        gd = "git diff";
        gf = "git fetch";
        gm = "git merge";
        gr = "git rebase";
        gP = "git push";
        gp = "git pull";
        gu = "git unstage";
        gco = "git checkout";
        gb = "git branch";
        lg = "lazygit";
      };
    };

    home.packages = with pkgs; [
      bobshell
      # dua disk usage analyzer
      dua

      # fd, modern find
      fd
      gnumake
      # neofetch is a terminal program to display system info
      neofetch
      # tlrc is the Rust client for tldr (which is npm)
      tlrc
      taskjuggler
      # ripgrep, modern grep
      ripgrep
      # wget, needed for vscode
      wget

      ## Nerdfonts
      nerd-fonts.fira-code
      # other fonts
      noto-fonts
      noto-fonts-color-emoji
    ];

    # required to autoload fonts from packages installed via Home Manager
    fonts.fontconfig.enable = true;

    fonts.fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "FiraCode" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };

    ## My programs

    programs.git = {
      enable = true;
      # set the git userName and userEmail in the host's home.nix
      # userName = "Will Parkin";
      # userEmail = "wmparkin@gmail.com";
      settings = {
        branch.autosetupmerge = true;
        color.ui = "auto";
        diff.tool = "vimdiff";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

}
