{
  description = "My Flake for NixOS and Home Manager configs";

  ## Note that i'm finding nix-starter-configs to be very helpful
  # https://github.com/Misterio77/nix-starter-configs

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      username = "parkin";
      galacticboi-host = "galacticboi-nixos";
      galacticboi-system = "x86_64-linux";
    in
    {
      ## Standalone home-manager config entrypoint.
      # Available through `nh home switch`
      # (Also available through `home-manager --flake .#your-username@your-hostname`)
      homeConfigurations = {
        ## standard installation
        "${username}@${galacticboi-host}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "${galacticboi-system}"; };
          extraSpecialArgs = {
            inherit inputs outputs;
          };

          modules = [ ./hosts/laptop/home.nix ];

        };

        "parkin@wsl-nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "${galacticboi-system}"; };
          extraSpecialArgs = {
            inherit inputs outputs;
          };

          modules = [ ./hosts/wsl/home.nix ];

        };
      };

      ## NixOS config entrypoint
      # Available through `nh os switch`
      # (Also available without `nh` through `nixos-rebuild --flake .#your-hostname`)
      nixosConfigurations = {
        "${galacticboi-host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/laptop/configuration.nix ];
        };

        wsl-nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            nixos-wsl.nixosModules.default
            ./hosts/wsl/configuration.nix
          ];
        };

      };

    };
}
