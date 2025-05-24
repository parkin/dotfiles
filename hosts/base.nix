{
  lib,
  config,
  ...
}:
let
  username = "parkin";
in
{
  options = {
    ## global options for my config
    mynixos = {

      username = lib.mkOption {
        description = "Default username";
        default = username;
        type = lib.types.str;
      };

      dotfilesPath = lib.mkOption {
        description = "Full absolute path to dotfiles directory. Eg /home/parkin/.dotfiles";
        default = "/home/${config.mynixos.username}/.dotfiles";
        type = lib.types.path;
      };
    };
  };
  config = {
    # enable flake support
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

  };
}
