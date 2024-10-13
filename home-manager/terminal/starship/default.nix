{
  lib,
  config,
  ...
}:
{
  options = {
    starship.enable = lib.mkEnableOption "Enables starship" // {
      default = true;
    };
  };
  config = lib.mkIf config.starship.enable {

    programs.starship = {
      enable = true;
    };
    xdg.configFile."starship.toml" = {
      source = ./starship.toml;
    };
  };
}
