{
  pkgs,
  ...
}:
{
  imports = [ ./base.nix ];

  config = {
    nix.package = pkgs.nix;
    # note that nix.settings.experimental-features is set in ./base.nix

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

  };
}
