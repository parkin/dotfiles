{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    myHomeManager.fzf.enable = lib.mkEnableOption "Enables fzf";
  };
  config = lib.mkIf config.myHomeManager.fzf.enable {
    home.packages = [
      pkgs.fzf
    ];

    # set up fzf key bindings and fuzzy completion
    programs.bash.initExtra = "eval \"\$(fzf --bash)\"";
    programs.zsh.initContent = ''source <(fzf --zsh)'';
  };

}
