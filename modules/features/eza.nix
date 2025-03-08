{
  config,
  lib,
  ...
}:
let
  ezaParams = " --git --group --icons --color=always";
  shellAliases = {
    ls = "eza" + ezaParams;
    ll = "eza -la --octal-permissions" + ezaParams;
    la = "eza --long --all" + ezaParams;
    lt = "eza --tree" + ezaParams;
    tree = "eza --tree" + ezaParams;
  };
in
{

  options = {
    myHomeManager.eza.enable = lib.mkEnableOption "Enables eza";
  };
  config = lib.mkIf config.myHomeManager.eza.enable {
    programs.eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    programs.bash.shellAliases = shellAliases;
    programs.zsh.shellAliases = shellAliases;
  };
}
