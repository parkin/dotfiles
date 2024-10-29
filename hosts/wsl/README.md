# wsl

This is for my [WSL2](https://learn.microsoft.com/en-us/windows/wsl/about) instance of [NixOS](https://nixos.org/).

## NixOS config

### CA Certs

See [./certificates.nix](./certificates.nix) for important info regarding CA Certs needed for the site's vpn.
There are some scripts you need to run first on Windows to generate your certs.

To prepare the certs you need while on your vpn, you need to run this script in Windows.

1. Clone [windows-certs-2-wsl](https://github.com/bayaro/windows-certs-2-wsl) into the ${windows-certs-2-wsl-dir} in [./certificates.nix](./certificates.nix) (I used commit ec5cebf).
2. After cloning, in PowerShell run `.\get-all-certs-.ps1` to execute the script.
   The script will populate a subdirectory `all-certificates` in the git repo.
3. [./certificates.nix](./certificates.nix) points to the `all-certificates` directory in the Windows partition so that it can include the certificates.
