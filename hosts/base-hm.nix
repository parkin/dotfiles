{
  pkgs,
  ...
}:
{
  imports = [ ./base.nix ];

  config = {
    nix.package = pkgs.nix;
    # Note: I set nix.settings.experimental-features in ./base.nix

    nixpkgs.config = {
      allowUnfree = true;
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

  };
}
