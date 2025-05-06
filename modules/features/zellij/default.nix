{
  pkgs-unstable,
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.zellij.enable = lib.mkEnableOption "Enables zellij";
  };

  config = lib.mkIf config.myHomeManager.zellij.enable {
    home.packages = [
      pkgs-unstable.zellij

    ];
    xdg.configFile."zellij/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.myHomeManager.dotfilesPath}/modules/features/zellij/config.kdl";
    };
    # the older version wasn't working well for me yet on nix
    # programs.zellij = {
    #   enable = true;
    #   enableBashIntegration = true;
    #   enableZshIntegration = true;
    #   # extraConfig = (builtins.readFile ./config.kdl); # this istn' right
    # };
  };
}
