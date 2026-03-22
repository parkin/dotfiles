{
  nixos-unstable,
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.zellij.enable = lib.mkEnableOption "Enables zellij";
    myHomeManager.zellij.configSource = lib.mkOption {
      type = lib.types.str;
      default = "${config.mynixos.dotfilesPath}/modules/features/zellij/config.kdl";
      description = "Path to the zellij config.kdl source file";
    };
  };

  config = lib.mkIf config.myHomeManager.zellij.enable {
    home.packages = [
      nixos-unstable.zellij

    ];
    # allow for overriding the locked keybind
    xdg.configFile."zellij/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink config.myHomeManager.zellij.configSource;
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
