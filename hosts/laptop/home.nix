args@{
  pkgs,
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

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  imports = [
    # base config to enable flakes and such
    ../base.nix
    # this syntax to pass argument dotfilesPath to this import
    # Neovim setup
    (import ../../home-manager/programs/neovim (args // { dotfilesPath = dotfilesPath; }))

    # full terminal setup done in this file
    (import ../../home-manager/terminal/terminal.nix (
      args
      // {
        dotfilesDir = dotfilesDir;
        dotfilesPath = dotfilesPath;
      }
    ))
  ];

  ## Options for my personal modules.
  ## These options are defined in the modules imported above.
  myHomeManager = {
    neovim.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.bitwarden-desktop

    ## obsidian md
    pkgs.obsidian
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file =
    {
    };

}
