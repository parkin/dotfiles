{
  description = "My Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      username = "parkin";
      galacticboi-host = "galacticboi-nixos";
    in
    {

      # for `nix run .` enablement
      defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

      ## Standalone home-manager config entrypoint.
      # Available through `home-manager --flake .#your-username@your-hostname`
      homeConfigurations = {
        "${username}@${galacticboi-host}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          extraSpecialArgs = {
            inherit inputs outputs;
          };

          modules = [ ./home.nix ];

        };
      };

    };
}
