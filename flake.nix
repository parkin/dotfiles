{
  description = "My Home Manager flake";

  ## Note that i'm finding nix-starter-configs to be very helpful
  # https://github.com/Misterio77/nix-starter-configs

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # in-nix.url = "github:viperML/in-nix";
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
      galacticboi-system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${galacticboi-system};
    in
    {

      # inputs.in-nix.packages.x86_64-linux.default.patchNix = pkgs.nix;

      devShells.${galacticboi-system}.default =
        with pkgs;
        mkShell {
          buildInputs = [
            just
          ];
        };

      ## Standalone home-manager config entrypoint.
      # Available through `home-manager --flake .#your-username@your-hostname`
      homeConfigurations = {
        "${username}@${galacticboi-host}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          extraSpecialArgs = {
            inherit inputs outputs;
          };

          modules = [ ./home-manager/home.nix ];

        };
      };

      ## NixOS config entrypoint
      # Available through `nixos-rebuild --flake .#your-hostname`
      nixosConfigurations = {
        ${galacticboi-host} = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/configuration.nix ];
        };
      };

    };
}
