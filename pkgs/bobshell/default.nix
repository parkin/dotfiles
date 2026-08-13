{
  lib,
  fetchurl,
  fetchzip,
  makeWrapper,
  nodejs_22,
  cacert,
  coreutils,
  curl,
  gnused,
  gnugrep,
  procps,
  pkgs ? import <nixpkgs> { },
}:

let
  # Fetch the @lydell/node-pty dependency from npm registry
  nodePty = fetchzip {
    url = "https://registry.npmjs.org/@lydell/node-pty/-/node-pty-1.1.0.tgz";
    hash = "sha256-JDcDoFNU+T2kbjh9PlWw6zJJurjHqWe5CrBV08ONTiw=";
    stripRoot = false;
  };

  # Fetch the platform-specific binary for linux-x64
  nodePtyLinuxX64 = fetchzip {
    url = "https://registry.npmjs.org/@lydell/node-pty-linux-x64/-/node-pty-linux-x64-1.1.0.tgz";
    hash = "sha256-xAFMHyBpWIF6L3z7dcnuZYyhFKnjKzGmrpaCPxzfi2Y=";
    stripRoot = false;
  };
in
pkgs.stdenv.mkDerivation rec {
  pname = "bobshell";
  version = "2.0.1";

  src = fetchurl {
    url = "http://bob-bot1.fyre.ibm.com:3000/cos-assets/bobshell/bobshell-${version}.tgz";
    sha256 = "sha256-gdu4WS6pv+uQLwEVfyMx2WeLl1ZTP9UuzrBelcJVhak=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs_22
  ];

  # CRITICAL: Prevent Nix from modifying files
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;

  unpackPhase = ''
    runHook preUnpack
    mkdir -p bobshell
    tar xzf $src -C bobshell --strip-components=1
    cd bobshell
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild

    # Create node_modules directory and install the dependencies
    mkdir -p node_modules/@lydell
    cp -r ${nodePty}/package node_modules/@lydell/node-pty
    cp -r ${nodePtyLinuxX64}/package node_modules/@lydell/node-pty-linux-x64

    runHook postBuild
  '';

  installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/bobshell
        cp -r . $out/lib/bobshell/
        
        mkdir -p $out/bin

        # Create wrapper that calls bob.js directly without modifying it
        # bob.js uses the hash of its own file to decrypt a secret
        # so we need to NOT modify it
        makeWrapper ${nodejs_22}/bin/node $out/bin/bob \
          --add-flags "$out/lib/bobshell/dist/bob.js" \
          --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
          --set SSL_CERT_DIR "${cacert}/etc/ssl/certs" \
          --prefix PATH : ${
            lib.makeBinPath [
              nodejs_22
              coreutils
              curl
              gnused
              gnugrep
              procps
            ]
          }

        # Create bob-check-latest-version command that compares versions
        cat > $out/bin/bob-check-latest-version <<'EOF'
    #!/usr/bin/env bash
    set -euo pipefail

    LATEST=$(${curl}/bin/curl -s https://s3.us-south.cloud-object-storage.appdomain.cloud/bobshell/bobshell-version.txt)
    CURRENT=$(bob --version 2>/dev/null | ${gnused}/bin/sed 's/^v//' || echo "unknown")

    echo "Current version: $CURRENT"
    echo "Latest version:  $LATEST"

    if [ "$CURRENT" = "$LATEST" ]; then
      echo "✓ You are running the latest version"
      exit 0
    elif [ "$CURRENT" = "unknown" ]; then
      echo "⚠ Could not determine current version"
      exit 1
    else
      echo "⚠ A newer version is available"
      exit 0
    fi
    EOF
        chmod +x $out/bin/bob-check-latest-version

        runHook postInstall
  '';

  meta = with lib; {
    description = "IBM Bob Shell - AI-powered development assistant";
    platforms = platforms.unix;
    mainProgram = "bob";
  };
}
