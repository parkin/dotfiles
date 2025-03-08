{
  pkgs,
  pkgs-unstable,
  ...
}:
let
  username = "parkin";
  homeDirectory = "/home/parkin";
  dotfilesDir = ".dotfiles";
  dotfilesPath = "${homeDirectory}/${dotfilesDir}";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${username}";
  home.homeDirectory = "${homeDirectory}";
  programs.git.userName = "Will Parkin";
  programs.git.userEmail = "wmparkin@gmail.com";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  imports = [
    # base config to enable flakes and such
    ../base.nix
    # my config modules
    ../../modules
  ];

  ## Options for my personal modules.
  ## These options are defined in the modules imported above.
  myHomeManager = {
    anki.enable = true;
    bundles.terminal.enable = true;
    # paths for use in these modules (eg neovim and terminal)
    dotfilesPath = dotfilesPath;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bitwarden-desktop
    megasync
    ## obsidian md
    obsidian

    ## unstable packages
    # TODO: nixpkgs 24.11, cryptomator 1.14.1 marked broken.
    # Need to use unstable for now to use cryptomator 1.14.2.
    # Switch to nixpkgs-stable when cryptomator no longer broken.
    pkgs-unstable.cryptomator
  ];

  ######## Browser
  programs.firefox.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
    };
  };

  programs.chromium = {
    enable = true;
    extensions = [
      ## Yomitan Popup Dictionary
      { id = "likgccmbimhjbgkjambclfkhldnlhbnn"; }
    ];
  };

  ######## /Browser

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

}
