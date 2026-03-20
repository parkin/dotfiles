{ config, pkgs, ... }:

{
  imports = [
    ../base-os.nix
    ./disko.nix
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Networking
  networking.hostName = config.mynixos.hostName;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  # Timezone
  time.timeZone = "America/New_York";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    htop
    kitty.terminfo
  ];

  security.sudo.wheelNeedsPassword = false;

  # User
  users.users.${config.mynixos.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
      ./ssh_key.pub
    ];
  };

  users.users.root.openssh.authorizedKeys.keyFiles = [
    ./ssh_key.pub
  ];

  system.stateVersion = "25.11";
}
