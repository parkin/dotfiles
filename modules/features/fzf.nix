{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.fzf
  ];

  # set up fzf key bindings and fuzzy completion
  programs.bash.initExtra = "eval \"\$(fzf --bash)\"";
  programs.zsh.initExtra = ''source <(fzf --zsh)'';

}
