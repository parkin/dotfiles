{
  nixos-unstable,
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.zellij.enable = lib.mkEnableOption "Enables zellij";
    myHomeManager.zellij.lockKeybind = lib.mkOption {
      type = lib.types.str;
      default = "Ctrl a";
      description = "Keybind to switch from locked mode to normal mode in zellij";
    };
    myHomeManager.zellij.theme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-macchiato";
      description = "Zellij color theme";
    };
  };

  config = lib.mkIf config.myHomeManager.zellij.enable {
    home.packages = [
      nixos-unstable.zellij

    ];
    # allow for overriding the locked keybind
    xdg.configFile."zellij/config.kdl" = {
      text =
        builtins.replaceStrings
          [
            "bind \"Ctrl a\" { SwitchToMode \"normal\"; }"
            "theme \"catppuccin-macchiato\""
          ]
          [
            "bind \"${config.myHomeManager.zellij.lockKeybind}\" { SwitchToMode \"normal\"; }"
            "theme \"${config.myHomeManager.zellij.theme}\""
          ]
          (builtins.readFile ./config.kdl);
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
