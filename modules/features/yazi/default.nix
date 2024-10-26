{
  config,
  lib,
  ...
}:
{
  options = {
    myHomeManager.yazi.enable = lib.mkEnableOption "Enables yazi";
  };

  config = lib.mkIf config.myHomeManager.yazi.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      shellWrapperName = "y";
    };

  };

}
