{
  config,
  lib,
  pkgs,
  ...
}:
let
  shellAliases = {
    cat = "bat";
  };
in
{
  options = {
    myHomeManager.bat.enable = lib.mkEnableOption "Enables bat";
  };
  config = lib.mkIf config.myHomeManager.bat.enable {
    home.packages = [
      ## bat is modern cat
      pkgs.bat
    ];

    programs.bash.shellAliases = shellAliases;
    programs.zsh.shellAliases = shellAliases;
  };
}
