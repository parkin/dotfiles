{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    ## bat is modern cat
    pkgs.bat
  ];

  programs.bash = {
    shellAliases = {
      cat = "bat";
    };
  };
}
