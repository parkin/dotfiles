{
  description = "My Flake for NixOS and Home Manager configs";

  ## Note that i'm finding nix-starter-configs to be very helpful
  # https://github.com/Misterio77/nix-starter-configs

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-wsl,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      username = "parkin";
      galacticboi-host = "galacticboi-nixos";
      wsl-host = "wsl-nixos";
      systemDefault = "x86_64-linux";
    in
    {
      ## Standalone home-manager config entrypoint.
      # Available through `nh home switch`
      # (Also available through `home-manager --flake .#your-username@your-hostname`)
      homeConfigurations = {
        ## standard installation
        "${username}@${galacticboi-host}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "${systemDefault}";
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs outputs;
            # pass unstable packages
            pkgs-unstable = import nixpkgs-unstable {
              system = "${systemDefault}";
              config.allowUnfree = true;
            };
          };

          modules = [
            ./hosts/laptop/home.nix
            # pass the hostname and username as module options
            {
              config.mynixos.hostName = galacticboi-host;
              config.mynixos.username = username;
            }
          ];

        };

        ## WSL
        "${username}@${wsl-host}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "${systemDefault}"; };
          extraSpecialArgs = {
            inherit inputs outputs;
            # pass unstable packages
            pkgs-unstable = import nixpkgs-unstable {
              system = "${systemDefault}";
              config.allowUnfree = true;
            };
          };

          modules = [
            ./hosts/wsl/home.nix
            {
              config.mynixos.hostName = wsl-host;
              config.mynixos.username = username;
            }
          ];

        };
      };

      ## NixOS config entrypoint
      # Available through `nh os switch`
      # (Also available without `nh` through `nixos-rebuild --flake .#your-hostname`)
      nixosConfigurations = {
        ## Home laptop
        "${galacticboi-host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/laptop/configuration.nix
            {
              config.mynixos.hostName = galacticboi-host;
              config.mynixos.username = username;
            }
          ];
        };

        ## WSL
        "${wsl-host}" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            nixos-wsl.nixosModules.default
            ./hosts/wsl/configuration.nix
            {
              config.mynixos.hostName = wsl-host;
              config.mynixos.username = username;
            }
          ];
        };

      };

    };
}
