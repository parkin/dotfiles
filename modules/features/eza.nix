{
  ...
}:
let
  ezaParams = " --git --group --icons --color=always";
  shellAliases = {
    ls = "eza" + ezaParams;
    l = "eza --git-ignore" + ezaParams;
    ll = "eza -la --octal-permissions" + ezaParams;
    la = "eza --long --all" + ezaParams;
    lt = "eza --tree" + ezaParams;
    tree = "eza --tree" + ezaParams;
  };
in
{

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bash.shellAliases = shellAliases;
  programs.zsh.shellAliases = shellAliases;
}
