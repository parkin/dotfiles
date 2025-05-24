# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  pkgs,
  config,
  ...
}:
let
  # see this documentation before changing the username on WSL
  # https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
  hostName = "wsl-nixos";
in
{
  # optimize storage periodically
  # see https://nixos.wiki/wiki/Storage_optimization
  nix.optimise.automatic = true;

  imports = [
    # include NixOS-WSL modules
    # <nixos-wsl/modules> # removed, these are now included in my flake.nix
    ./certificates.nix
    # include base
    ../base-os.nix
  ];

  networking.hostName = "${hostName}";

  wsl = {
    enable = true;
    defaultUser = config.mynixos.username;
    startMenuLaunchers = true;
    # skip path inclusion
    # not sure why we have to choose both
    interop = {
      includePath = false;
      register = true;
    };
    wslConf.interop = {
      enabled = true;
      appendWindowsPath = false;
    };
  };

  # mount the Windows Box folder
  fileSystems."/mnt/box" = {
    device = "C:\\users\\8J5204897\\box";
    fsType = "drvfs";
  };

  # needed to use this to get pixi envs to work
  programs.nix-ld.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    # add an editor in case we can't access the user for some reason
    neovim
    # WSL utilities
    wslu
    # kitty system wide so we can start it
    kitty
  ];

}
