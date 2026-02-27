{
  lib,
  config,
  nixos-unstable,
  ...
}:
let
  statusLineFile = "statusline.sh";
  settingsFile = "settings.json";
  statusLineFullPath = "${config.mynixos.dotfilesPath}/modules/features/claude-code/${statusLineFile}";
  settingsFullPath = "${config.mynixos.dotfilesPath}/modules/features/claude-code/${settingsFile}";
in
{
  options = {
    myHomeManager.claude-code.enable = lib.mkEnableOption "Enables claude-code" // {
      default = false;
    };
  };
  config = lib.mkIf config.myHomeManager.claude-code.enable {

    home.packages = [
      nixos-unstable.claude-code
    ];

    home.file.".claude/${statusLineFile}" = {
      source = config.lib.file.mkOutOfStoreSymlink statusLineFullPath;
    };
    home.file.".claude/${settingsFile}" = {
      source = config.lib.file.mkOutOfStoreSymlink settingsFullPath;
    };
  };
}
