{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.tmux.enable = lib.mkEnableOption "Enables tmux";
  };
  config = lib.mkIf config.myHomeManager.tmux.enable {

    home.packages = [
      pkgs.tmux
    ];

    # copy the config file
    home.file = {
      ".tmux.conf".source = ./.tmux.conf;
    };
  };
}
