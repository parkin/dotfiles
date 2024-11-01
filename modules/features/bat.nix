{
  pkgs,
  ...
}:
let
  shellAliases = {
    cat = "bat";
  };
in
{
  home.packages = [
    ## bat is modern cat
    pkgs.bat
  ];

  programs.bash.shellAliases = shellAliases;
  programs.zsh.shellAliases = shellAliases;
}
