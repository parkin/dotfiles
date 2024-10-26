{
  config,
  lib,
  pkgs,
  ...
}:
let
  yaziFlavors = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "main";
    sha256 = "sha256-a9Ta0dLuxqay0TwcoAOzcQ0aqm40RyzFxXb25Qf8jcQ=";
  };
  myFlavor = "catppuccin-frappe";
in
{
  options = {
    myHomeManager.yazi.enable = lib.mkEnableOption "Enables yazi";
  };

  config = lib.mkIf config.myHomeManager.yazi.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      shellWrapperName = "y";
      flavors = {
        ${myFlavor} = ''${yaziFlavors}/${myFlavor}.yazi'';
      };
      theme = {
        flavor = {
          use = "${myFlavor}";
        };
      };
    };
  };

}
