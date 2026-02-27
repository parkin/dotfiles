{
  pkgs ? import <nixpkgs> { },
  fetchurl,
  nodejs_22,
  ...
}:

pkgs.stdenv.mkDerivation rec {
  # pkgs.buildNpmPackage rec {
  pname = "bobshell";
  version = "0.0.34"; # UPDATE THIS: Replace with actual version from bobshell-version.txt

  src = fetchurl {
    url = "http://bob-bot1.fyre.ibm.com:3000/cos-assets/bobshell/bobshell-${version}.tgz";
    sha256 = "0ivbddssxvhakqg1lz3s8vl5aw50074p23xifbwdbx8dvrnxv07s"; # UPDATE THIS: Run update-version.sh or use nix-prefetch-url
  };

  buildInputs = [
    nodejs_22
  ];

  unpackPhase = ''
    runHook preUnpack
    # Extract and see what we have
    tar xzf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # install the bob script
    mkdir -p $out/bin
    cp $NIX_BUILD_TOP/package/bundle/bob.js $out/bin/bobshell
    chmod +x $out/bin/bobshell

    # install the bobshell-latest-version command
    echo "curl -s https://s3.us-south.cloud-object-storage.appdomain.cloud/bobshell/bobshell-version.txt" >> $out/bin/bobshell-latest-version
    chmod +x $out/bin/bobshell-latest-version

    runHook postInstall
  '';

}
