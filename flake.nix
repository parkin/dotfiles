{
  description = "My Flake for NixOS and Home Manager configs";

  ## Note that i'm finding nix-starter-configs to be very helpful
  # https://github.com/Misterio77/nix-starter-configs

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    taskeru = {
      url = "git+ssh://git@github.com/parkin/taskeru.git?ref=refs/tags/v0.11.0";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-unstable,
      home-manager,
      nixos-wsl,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      defaultUsername = "parkin";
      galacticboi-host = "galacticboi-nixos";
      wsl-host = "wsl-nixos";
      dell-wsl-host = "dell-wsl-nixos";
      systemDefault = "x86_64-linux";

      overlays = [
        (final: prev: {
          bobshell = final.callPackage ./pkgs/bobshell { };
        })
      ];

      pkgs = import nixpkgs {
        system = systemDefault;
        overlays = overlays;
      };
      # helper function for setting config.mynixos options
      mkMyNixosOpts =
        { hostname, username, ... }:
        {
          config.mynixos.hostName = hostname;
          config.mynixos.username = username;
        };
      # helper function for homeManagerConfiguration for code reuse
      mkHomeConfig =
        args@{ hostname, ... }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # pkgs = import nixpkgs {
          #   system = systemDefault;
          # };
          extraSpecialArgs = {
            inherit inputs outputs;
            # pass unstable packages
            nixos-unstable = import nixos-unstable {
              system = "${systemDefault}";
              config.allowUnfree = true;
            };
            # pass taskeru package
            taskeru = inputs.taskeru.packages.${systemDefault}.default;
          };
          modules = [
            ./hosts/${hostname}/home.nix
            (mkMyNixosOpts args) # pass the hostname and username as module options
          ];
        };
      # helper function for nixosSystem for code reuse
      mkNixOSConfig =
        args@{
          hostname,
          modules ? [ ],
          ...
        }:
        nixpkgs.lib.nixosSystem {
          system = systemDefault;
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            (mkMyNixosOpts args) # pass the hostname and username as module options
          ]
          ++ modules;
        };
    in
    {
      packages.${systemDefault}.bobshell = pkgs.bobshell;

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

        ## Dell-WSL
        "${defaultUsername}@${dell-wsl-host}" = mkHomeConfig {
          hostname = dell-wsl-host;
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

        ## Lenovo WSL
        "${wsl-host}" = mkNixOSConfig {
          hostname = wsl-host;
          username = defaultUsername;
          modules = [
            nixos-wsl.nixosModules.default
          ];
        };

        ## Dell WSL
        "${dell-wsl-host}" = mkNixOSConfig {
          hostname = dell-wsl-host;
          username = defaultUsername;
          modules = [
            nixos-wsl.nixosModules.default
          ];
        };

      };

    };
}
