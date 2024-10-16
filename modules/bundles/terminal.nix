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
    # bat is modern version of cat
    ../features/bat.nix
    # eza setup (modern `ls`)
    ../features/eza.nix
    # fzf setup
    ../features/fzf.nix
    # list files - terminal file manager
    ../features/lf
    # starship module
    ../features/starship
    # tmux
    ../features/tmux
  ];

  options = {
    myHomeManager.bundles.terminal.enable = lib.mkEnableOption "Enables my terminal bundle";
  };

  config = lib.mkIf config.myHomeManager.bundles.terminal.enable {

    # for my home manager modules
    myHomeManager = {
      lf.enable = true;
      tmux.enable = true;
    };

    home.packages = [

      # fd, modern find
      pkgs.fd
      # tlrc is the Rust client for tldr (which is npm)
      pkgs.tlrc
      # ripgrep, modern grep
      pkgs.ripgrep
      # wget, needed for vscode
      pkgs.wget

      ## Nerdfonts
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    ## My programs
    programs.bash = {
      enable = true;
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "~" = "cd ~";
        cddot = "cd ${config.myHomeManager.dotfilesPath}";
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
        gp = "git push";
        gu = "git unstage";
        gco = "git checkout";
        gb = "git branch";
      };
    };

    programs.git = {
      enable = true;
      userName = "Will Parkin";
      userEmail = "wmparkin@gmail.com";
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
  };

}
