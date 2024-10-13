## This file is for configuring the terminal / shell / etc...
{
  config,
  pkgs,
  dotfilesDir, # name of dotfiles dir, eg ".dotfiles"
  dotfilesPath, # full path to ~/.dotfiles directory
  ...
}:
{
  # imports for programs requiring special setup
  imports = [
    # fzf setup
    ./fzf.nix
    # eza setup (modern `ls`)
    ./eza.nix
    # bat is modern version of cat
    ./bat.nix
    # tmux
    ./tmux
  ];

  home.packages = [

    # fd, modern find
    pkgs.fd
    # tlrc is the Rust client for tldr (which is npm)
    pkgs.tlrc
    ## tmux
    # pkgs.tmux
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

  ############ Starship
  programs.starship = {
    enable = true;
  };
  xdg.configFile."starship.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/homedir/config/starship.toml";
  };
  ############ /Starship

}
