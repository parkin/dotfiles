{
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.zsh.enable = lib.mkEnableOption "Enables zsh";
  };

  config = lib.mkIf config.myHomeManager.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 10000;
      };
      shellAliases = {
        ll = "ls -l";
        ".." = "cd ..";
      };
    };
  };

}
