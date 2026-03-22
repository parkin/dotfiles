{
  config,
  ...
}:
{
  imports = [
    ../base-hm.nix
    ../../modules/bundles/terminal.nix
  ];

  home.username = "${config.mynixos.username}";
  home.homeDirectory = "/home/${config.home.username}";

  programs.git.settings.user = {
    name = "Will Parkin";
    email = "wmparkin@gmail.com";
  };

  myHomeManager = {
    bundles.terminal.enable = true;
    claude-code.enable = true;
    zellij.lockKeybind = "Ctrl b";
    zellij.theme = "gruvbox-dark";
  };

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11";
}
