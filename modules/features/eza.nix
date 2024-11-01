{
  pkgs,
  ...
}:
let
  shellAliases = {
    ls = "eza --color=always --icons";
    ll = "eza -la --icons --octal-permissions";
    la = "eza --long --all --group";
  };
in
{
  home.packages = [
    ## eza -- modern `ls`
    pkgs.eza
  ];

  programs.bash.shellAliases = shellAliases;
  programs.zsh.shellAliases = shellAliases;
}
