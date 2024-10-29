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

    home.packages = with pkgs; [
      tmux
    ];

    # copy the config file
    home.file.".tmux.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.myHomeManager.dotfilesPath}/modules/features/tmux/.tmux.conf";
    };
  };
}
