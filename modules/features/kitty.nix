{
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.kitty.enable = lib.mkEnableOption "Enables kitty";
  };
  config = lib.mkIf config.myHomeManager.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      shellIntegration.enableZshIntegration = true;
      settings = {
        background_opacity = "0.85";
        background_blur = 10;
      };
    };
  };

}
