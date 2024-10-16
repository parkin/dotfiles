## This file is for configuring the terminal / shell / etc...
{
  pkgs,
  dotfilesDir, # name of dotfiles dir, eg ".dotfiles"
  ...
}:
{
  # imports for programs requiring special setup
  imports = [
    # bat is modern version of cat
    ./bat.nix
    # eza setup (modern `ls`)
    ./eza.nix
    # fzf setup
    ./fzf.nix
    # list files - terminal file manager
    ./lf
    # starship module
    ./starship
    # tmux
    ./tmux
  ];

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
      cddot = "cd ~/${dotfilesDir}";
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

}
