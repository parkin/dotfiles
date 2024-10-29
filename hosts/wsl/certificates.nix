{
  lib,
  ...
}:
let
  windows-certs-2-wsl-dir = /mnt/c/Users/8J5204897/Documents/git/windows-certs-2-wsl;
  certDir = "${windows-certs-2-wsl-dir}/all-certificates";
in
{
  ##########
  # To prepare the certs you need while on your vpn, you need to run this script in Windows.
  # 1. Clone
  #   https://github.com/bayaro/windows-certs-2-wsl
  #   into the ${windows-certs-2-wsl-dir} above (I used commit ec5cebf).
  # 2. After cloning, in PowerShell run `.\get-all-certs-.ps1` to execute the script.
  #   The script will populate a subdirectory `all-certificates` in the git repo.

  ##
  ## The following code lists only the *.pem files in ${certDir} above.
  ## Code to list files in dir using wildcard was found at this link
  ## https://discourse.nixos.org/t/how-to-use-a-wildcard-in-a-path-expression/51083/6
  security.pki.certificateFiles = lib.pipe "${certDir}" [
    builtins.readDir
    (lib.filterAttrs (name: _: lib.hasSuffix ".pem" name))
    (lib.mapAttrsToList (name: _: "${certDir}" + "/${name}"))
  ];

  ## below is the standard way to do it, but the folder also contains `ca-certificates.crt`
  ## which will cause issues.
  ## we only want to pull the *.pem files from the folder, so using the above method does that.
  # security.pki.certificateFiles = lib.filesystem.listFilesRecursive "${certDir}";
}
