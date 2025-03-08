{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    myHomeManager.anki.enable = lib.mkEnableOption "Enables Anki";
  };

  config = lib.mkIf config.myHomeManager.anki.enable {
    home.packages = with pkgs; [
      anki-bin
      # mpv media player needed for audio
      mpv
    ];

  };
}
