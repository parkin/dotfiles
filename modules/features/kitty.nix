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
      font = {
        name = "FiraCode Nerd Font";
      };
      settings = {
        background_opacity = "0.85";
        background_blur = 10;
        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";
      };
    };
  };

}
