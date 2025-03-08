{
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.starship.enable = lib.mkEnableOption "Enables starship" // {
      default = true;
    };
  };
  config = lib.mkIf config.myHomeManager.starship.enable {

    programs.starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    xdg.configFile."starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.myHomeManager.dotfilesPath}/modules/features/starship/starship.toml";
    };
  };
}
