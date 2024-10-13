{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    tmux.enable = lib.mkEnableOption "Enables tmux" // {
      default = true;
    };
  };
  config = lib.mkIf config.tmux.enable {

    home.packages = [
      pkgs.tmux
    ];

    # copy the config file
    home.file = {
      ".tmux.conf".source = ./.tmux.conf;
    };
  };
}
