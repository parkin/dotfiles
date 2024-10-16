# lf is terminal file manager
# https://github.com/gokcehan/lf
{
  config,
  lib,
  ...
}:
{

  options = {
    myHomeManager.lf.enable = lib.mkEnableOption "Enables lf";
  };

  config = lib.mkIf config.myHomeManager.lf.enable {
    xdg.configFile."lf/lfrc".source = ./lfrc;
    xdg.configFile."lf/icons".source = ./icons;

    programs.lf = {
      enable = true;
    };

  };

}
