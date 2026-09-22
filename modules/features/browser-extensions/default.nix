{
  lib,
  config,
  ...
}:
let
  moduleDir = "${config.mynixos.dotfilesPath}/modules/features/browser-extensions";

  # Link a backup file into $HOME only once it has actually been exported, so
  # the config still evaluates before the first export instead of leaving a
  # dangling symlink behind.
  #
  # Existence is tested against ./. (the store copy of this directory) rather
  # than moduleDir: a path outside the store reads as missing under pure
  # evaluation, which would silently drop every file here on `nh home switch`.
  # The symlink itself still points at the live repo via moduleDir.
  linkIfPresent =
    name:
    lib.optionalAttrs (builtins.pathExists (./. + "/${name}")) {
      ${name}.source = config.lib.file.mkOutOfStoreSymlink "${moduleDir}/${name}";
    };
in
{
  options = {
    myHomeManager.browser-extensions.enable =
      lib.mkEnableOption "Enables version-controlled browser extension settings";
  };

  config = lib.mkIf config.myHomeManager.browser-extensions.enable {
    # Yomitan and asbplayer keep their settings in chrome.storage.local and
    # neither declares a managed_schema, so Chromium's enterprise policy cannot
    # seed them. The next best thing is to version their own backup files here
    # and import them from each extension's settings page:
    #
    #   Yomitan    settings -> Backup -> Import Settings
    #   asbplayer  options  -> Import Settings
    #
    # These are out-of-store symlinks, so re-exporting over them writes straight
    # back into the dotfiles repo and `git diff` shows what changed.
    #
    # Yomitan dictionaries live in IndexedDB and are NOT part of the settings
    # backup -- it only references them by name. Re-import the dictionary zips,
    # or use Yomitan's Export/Import Dictionary buttons, on a fresh machine.
    home.file = linkIfPresent "yomitan-settings.json" // linkIfPresent "asbplayer-settings.json";
  };
}
