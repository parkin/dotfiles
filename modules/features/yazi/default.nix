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
    rev = "f6b425a";
    sha256 = "sha256-bavHcmeGZ49nNeM+0DSdKvxZDPVm3e6eaNmfmwfCid0=";
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
