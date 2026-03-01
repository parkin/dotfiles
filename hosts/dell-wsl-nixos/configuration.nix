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
{
  # optimize storage periodically
  # see https://nixos.wiki/wiki/Storage_optimization
  nix.optimise.automatic = true;

  imports = [
    # include base
    ../base-os.nix
  ];

  networking.hostName = config.mynixos.hostName;

  wsl = {
    enable = true;
    # see this documentation before changing the username on WSL
    # https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
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
    device = "C:\\users\\WillParkin\\box";
    fsType = "drvfs";
  };

  # enable OpenGL / GPU Support
  hardware.graphics.enable = true;
  hardware.opengl.enable = true;

  wsl.useWindowsDriver = true;

  # Make the WSL CUDA libraries available system-wide

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
  system.stateVersion = "25.05"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    # for WSL CUDA gpu libraries
    cudatoolkit
    # add an editor in case we can't access the user for some reason
    neovim
    # WSL utilities
    wslu
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  environment.sessionVariables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
    LD_LIBRARY_PATH = [
      "/usr/lib/wsl/lib"
      "${pkgs.linuxPackages.nvidia_x11}/lib"
      "${pkgs.ncurses5}/lib"
    ];
    MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = false;
  };

  systemd.services = {
    nvidia-cdi-generator = {
      description = "Generate nvidia cdi";
      wantedBy = [ "docker.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.nvidia-docker}/bin/nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml --nvidia-ctk-path=${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk";
      };
    };
  };

  virtualisation.docker = {
    daemon.settings.features.cdi = true;
    daemon.settings.cdi-spec-dirs = [ "/etc/cdi" ];
  };

}
