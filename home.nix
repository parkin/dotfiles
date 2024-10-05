{
  config,
  pkgs,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "parkin";
  home.homeDirectory = "/home/parkin";

  # this is to ensure apps show up in applications menu
  # https://github.com/nix-community/home-manager/issues/1439#issuecomment-1106208294
  # home.activation = {
  #   linkDesktopApplications = {
  #     after = ["writeBoundary" "createXdgUserDirectories"];
  #     before = [];
  #     data = ''
  #       rm -rf ${config.xdg.dataHome}/"applications/home-manager"
  #       mkdir -p ${config.xdg.dataHome}/"applications/home-manager"
  #       cp -Lr ${config.home.homeDirectory}/.nix-profile/share/applications/* ${config.xdg.dataHome}/"applications/home-manager/"
  #     '';
  #   };
  # };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.bitwarden-desktop

    ## obsidian md
    pkgs.obsidian

    ## tmux
    pkgs.tmux

    ## just for project-specific commands
    pkgs.just

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/parkin/etc/profile.d/hm-session-vars.sh
  #

  ## neovim import
  imports = [ ./nvim.nix ];

  ## My programs
  programs.bash = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "~" = "cd ~";
      cddot = "cd ~/.dotfiles"; # FIX: use variable for dotfiles path
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
    # FIX: use variables for dotfiles
    source = config.lib.file.mkOutOfStoreSymlink "/home/parkin/.dotfiles/config/starship.toml";
  };
  programs.bash = {
    bashrcExtra = ''
      eval "$(starship init bash)"
    '';
  };
  ############ /Starship

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
