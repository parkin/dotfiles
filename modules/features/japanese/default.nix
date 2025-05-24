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
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk # alternatively, kdePackages.fcitx5-qt
        fcitx5-mozc # table input method support
        fcitx5-tokyonight
      ];
    };

    home.packages = with pkgs; [
      # TODO: enable this extension with nix
      gnomeExtensions.kimpanel

      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];

    fonts.fontconfig.enable = true;

    fonts.fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans JP" ];
      serif = [ "Noto Serif JP" ];
    };

    # this adds a config file.
    # Not strictly needed, but I'm using to set Hiragana mode on start.
    # See:
    # https://github.com/google/mozc/blob/master/docs/configurations.md
    # https://github.com/google/mozc/discussions/925
    xdg.configFile."mozc/ibus_config.textproto" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.myHomeManager.dotfilesPath}/modules/features/japanese/ibus_config.textproto";
    };

  };

}
