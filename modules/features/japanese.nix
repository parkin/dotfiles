{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    myHomeManager.japanese.enable = lib.mkEnableOption "Enables Japanese Input";
  };
  config = lib.mkIf config.myHomeManager.japanese.enable {

    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk # alternatively, kdePackages.fcitx5-qt
        fcitx5-mozc # table input method support
        fcitx5-tokyonight
      ];
    };

    home.packages = with pkgs; [
      gnomeExtensions.kimpanel
      ipafont
      kochi-substitute
      noto-fonts-cjk-sans
    ];

  };

}
