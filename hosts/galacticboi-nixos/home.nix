{
  pkgs,
  nixos-unstable,
  nixpkgs-unstable,
  config,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "${config.mynixos.username}";
  home.homeDirectory = "/home/${config.home.username}";
  programs.git.userName = "Will Parkin";
  programs.git.userEmail = "wmparkin@gmail.com";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  imports = [
    # base config to enable flakes and such
    ../base-hm.nix
    # my config modules
    ../../modules
  ];

  ## Options for my personal modules.
  ## These options are defined in the modules imported above.
  myHomeManager = {
    anki.enable = true;
    bundles.terminal.enable = true;
    kitty.enable = true;
    japanese.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    audacity
    bitwarden-desktop
    cryptomator
    megasync
    ## obsidian md
    obsidian

    ## unstable packages
    # TODO: switch back to nixos-unstable after the QT 6.10 patch is merged into nixos-unstable
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/az/azahar/package.nix
    # nixos-unstable.azahar # Nintendo 3ds emulator
    nixpkgs-unstable.azahar # Nintendo 3ds emulator
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

}
