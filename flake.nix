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
      defaultUsername = "parkin";
      galacticboi-host = "galacticboi-nixos";
      wsl-host = "wsl-nixos";
      systemDefault = "x86_64-linux";
      # wrapped homeManagerConfiguration in a function for code reuse
      mkHomeConfig =
        { hostname, username, ... }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = systemDefault;
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
            ./hosts/${hostname}/home.nix
            # pass the hostname and username as module options
            {
              config.mynixos.hostName = hostname;
              config.mynixos.username = username;
            }
          ];
        };
      # wrapped nixosSystem in a function for code reuse
      mkNixOSConfig =
        {
          hostname,
          username,
          modules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          system = systemDefault;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            {
              config.mynixos.hostName = hostname;
              config.mynixos.username = username;
            }
          ] ++ modules;
        };
    in
    {
      ## Standalone home-manager config entrypoint.
      # Available through `nh home switch`
      # (Also available through `home-manager --flake .#your-username@your-hostname`)
      homeConfigurations = {
        ## standard installation
        "${defaultUsername}@${galacticboi-host}" = mkHomeConfig {
          hostname = galacticboi-host;
          username = defaultUsername;
        };

        ## WSL
        "${defaultUsername}@${wsl-host}" = mkHomeConfig {
          hostname = wsl-host;
          username = defaultUsername;
        };
      };

      ## NixOS config entrypoint
      # Available through `nh os switch`
      # (Also available without `nh` through `nixos-rebuild --flake .#your-hostname`)
      nixosConfigurations = {
        ## Home laptop
        "${galacticboi-host}" = mkNixOSConfig {
          hostname = galacticboi-host;
          username = defaultUsername;
        };

        ## WSL
        "${wsl-host}" = mkNixOSConfig {
          hostname = wsl-host;
          username = defaultUsername;
          modules = [
            nixos-wsl.nixosModules.default
          ];
        };

      };

    };
}
