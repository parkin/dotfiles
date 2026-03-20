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

  programs.git = {
    userName = "Will Parkin";
    userEmail = "wmparkin@gmail.com";
  };

  myHomeManager = {
    bundles.terminal.enable = true;
    claude-code.enable = true;
  };

  home.stateVersion = "25.11";
}
