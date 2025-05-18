{
  lib,
  config,
  pkgs,
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
      shellAliases = config.myHomeManager.terminal.shellAliases;
      plugins = [
        # see this issue with direnv and shell completions: https://github.com/direnv/direnv/issues/443
        # this plugin syncs zsh completions when new ones are added
        # which is needed for completions to work for things installed by direnv.
        # https://github.com/BronzeDeer/zsh-completion-sync
        {
          name = "zsh-completion-sync";
          src = pkgs.fetchFromGitHub {
            owner = "BronzeDeer";
            repo = "zsh-completion-sync";
            rev = "f6e95baf8cd87d9065516d1fa0bf0cb33b4235f3";
            sha256 = "sha256-XhZ7l8e2H1+W1oUkDrr8pQVPVbb3+1/wuu7MgXsTs+8=";
          };
        }
      ];
    };
  };

}
