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
      sansSerif = [ "Noto Sans CJK JP" ];
      serif = [ "Noto Serif CJK JP" ];
    };

    # fcitx5 generates this on first run with only keyboard-us in the group,
    # which makes the Ctrl+Space toggle a no-op. Tracking it here registers
    # mozc on a fresh install. fcitx5 writes through the symlink, so changes
    # made in fcitx5-configtool land as diffs in this repo.
    xdg.configFile."fcitx5/profile" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.mynixos.dotfilesPath}/modules/features/japanese/fcitx5/profile";
    };

    # this adds a config file.
    # Not strictly needed, but I'm using to set Hiragana mode on start.
    # See:
    # https://github.com/google/mozc/blob/master/docs/configurations.md
    # https://github.com/google/mozc/discussions/925
    xdg.configFile."mozc/ibus_config.textproto" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.mynixos.dotfilesPath}/modules/features/japanese/ibus_config.textproto";
    };

  };

}
