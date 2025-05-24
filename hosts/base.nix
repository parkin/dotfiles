{
  lib,
  config,
  ...
}:
{
  options = {
    ## global options for my config
    mynixos = {

      username = lib.mkOption {
        description = "Default username";
        type = lib.types.str;
      };

      dotfilesPath = lib.mkOption {
        description = "Full absolute path to dotfiles directory. Eg /home/parkin/.dotfiles";
        default = "/home/${config.mynixos.username}/.dotfiles";
        type = lib.types.path;
      };

      hostName = lib.mkOption {
        description = "hostName to be passed to network.hostName";
        type = lib.types.str;
      };
    };
  };
  config = {
    # enable flake support
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpgs.config.allowUnfree = true;

  };
}
