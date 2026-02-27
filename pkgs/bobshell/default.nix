{
  lib,
  fetchurl,
  makeWrapper,
  nodejs_22,
  coreutils,
  curl,
  gnused,
  gnugrep,
  procps,
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation rec {
  pname = "bobshell";
  version = "0.0.34";

  src = fetchurl {
    url = "http://bob-bot1.fyre.ibm.com:3000/cos-assets/bobshell/bobshell-${version}.tgz";
    sha256 = "sha256-pg9YnvGtpF6cPXKavUnMJmjgEQK3YfhtszTRCK95oeI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # CRITICAL: Prevent Nix from modifying files
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;
  dontFixup = false; # We need fixup for makeWrapper, but control what gets fixed

  unpackPhase = ''
    runHook preUnpack
    mkdir -p $out/lib/bobshell
    tar xzf $src -C $out/lib/bobshell --strip-components=1
    runHook postUnpack
  '';

  # Skip build phase entirely
  dontBuild = true;

  installPhase = ''
        runHook preInstall

        mkdir -p $out/bin

        # Create wrapper that calls bob.js directly without modifying it
        # bob.js uses the hash of its own file to decrypt a secret
        # so we need to NOT modify it
        makeWrapper ${nodejs_22}/bin/node $out/bin/bob \
          --add-flags "$out/lib/bobshell/bundle/bob.js" \
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

        # Create bob-latest-version command that compares versions
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

  # Don't patch shebangs in the bundle directory
  postFixup = ''
    # Restore original bob.js if it was modified
    chmod -R u+w $out/lib/bobshell/bundle/
  '';

  meta = with lib; {
    description = "IBM Bob Shell - AI-powered development assistant";
    platforms = platforms.unix;
    mainProgram = "bob";
  };
}
