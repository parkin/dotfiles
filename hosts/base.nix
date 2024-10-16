{
  pkgs,
  ...
}:
{
  config = {
    nix = {
      package = pkgs.nix;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

  };
}
