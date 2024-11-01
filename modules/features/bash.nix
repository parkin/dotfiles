{
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.bash.enable = lib.mkEnableOption "Enables bash";
  };

  config = lib.mkIf config.myHomeManager.bash.enable {
    programs.bash = {
      enable = true;
      shellAliases = config.myHomeManager.terminal.shellAliases;
      # Enable vi mode
      initExtra = ''
        set -o vi
      '';
    };

  };

}
