{
  lib,
  config,
  dotfilesPath,
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
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/home-manager/terminal/starship/starship.toml";
    };
  };
}
