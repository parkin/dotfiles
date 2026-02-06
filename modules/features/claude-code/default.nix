{
  lib,
  config,
  ...
}:
let
  statusLineFile = "statusline.sh";
  statusLineFullPath = "${config.mynixos.dotfilesPath}/modules/features/claude-code/${statusLineFile}";
in
{
  options = {
    myHomeManager.claude-code.enable = lib.mkEnableOption "Enables claude-code" // {
      default = true;
    };
  };
  config = lib.mkIf config.myHomeManager.claude-code.enable {

    programs.claude-code = {
      enable = true;
      settings = {
        enabledPlugins = {
          "gopls-lsp@claude-plugins-official" = true;
        };
        alwaysThinkingEnabled = true;
        statusLine = {
          type = "command";
          command = statusLineFullPath;
          padding = 2;
        };
      };

    };

    xdg.configFile.${statusLineFile} = {
      source = config.lib.file.mkOutOfStoreSymlink statusLineFullPath;
    };
  };
}
