{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.fzf
  ];

  programs.bash.initExtra = "eval \"\$(fzf --bash)\"";

}
