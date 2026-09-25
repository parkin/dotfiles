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

  # Platform-specific node-pty binary package
  nodePtyPlatform =
    let
      sources = {
        "x86_64-linux" = {
          url = "https://registry.npmjs.org/@lydell/node-pty-linux-x64/-/node-pty-linux-x64-1.1.0.tgz";
          hash = "sha256-xAFMHyBpWIF6L3z7dcnuZYyhFKnjKzGmrpaCPxzfi2Y=";
          pkgName = "node-pty-linux-x64";
        };
        "aarch64-linux" = {
          url = "https://registry.npmjs.org/@lydell/node-pty-linux-arm64/-/node-pty-linux-arm64-1.1.0.tgz";
          hash = "sha256-8bQx4XqKZHl4ZDWpEvEBXQIeWVc9L+Vb4TYo4cNogJM=";
          pkgName = "node-pty-linux-arm64";
        };
        "x86_64-darwin" = {
          url = "https://registry.npmjs.org/@lydell/node-pty-darwin-x64/-/node-pty-darwin-x64-1.1.0.tgz";
          hash = "sha256-ANCMTH7O1QyX/YjUbEcMl4up0SX92oQbsBCoRJuYiI4=";
          pkgName = "node-pty-darwin-x64";
        };
        "aarch64-darwin" = {
          url = "https://registry.npmjs.org/@lydell/node-pty-darwin-arm64/-/node-pty-darwin-arm64-1.1.0.tgz";
          hash = "sha256-6CF3sfXTMhd8FDAb6B3/hXaMI3ui6GAiOGfgKqY+ifU=";
          pkgName = "node-pty-darwin-arm64";
        };
      };
      srcInfo =
        sources.${pkgs.stdenv.hostPlatform.system}
          or (throw "Unsupported system for node-pty: ${pkgs.stdenv.hostPlatform.system}");
    in
    {
      inherit (srcInfo) pkgName;
      src = fetchzip {
        url = srcInfo.url;
        hash = srcInfo.hash;
        stripRoot = false;
      };
    };

  # Fetch the @officecli/officecli npm package
  officecli = fetchzip {
    url = "https://registry.npmjs.org/@officecli/officecli/-/officecli-1.0.144.tgz";
    hash = "sha256-lCPl3wPbY+KRFUe/a6Hchkw7566Oox3qX3dtjVmXicg=";
    stripRoot = false;
  };

  # Platform-specific officecli binary
  officecliBinary =
    let
      binaries = {
        "x86_64-linux" = fetchurl {
          url = "https://github.com/iOfficeAI/OfficeCLI/releases/download/v1.0.144/officecli-linux-x64";
          hash = "sha256-Mu96IaVKTKbJgGv16fPTK/sSkQFzKcVQRMsqrHGCLrg=";
        };
        "aarch64-linux" = fetchurl {
          url = "https://github.com/iOfficeAI/OfficeCLI/releases/download/v1.0.144/officecli-linux-arm64";
          hash = "sha256-VuwsMRS2b2SQiItneMu4QTplkRomysxyB/KeE0JJZto=";
        };
        "x86_64-darwin" = fetchurl {
          url = "https://github.com/iOfficeAI/OfficeCLI/releases/download/v1.0.144/officecli-mac-x64";
          hash = "sha256-NmEAZD11ew2iSClCKJfKdHaKiUtezRpHGhM2+OKgeH0=";
        };
        "aarch64-darwin" = fetchurl {
          url = "https://github.com/iOfficeAI/OfficeCLI/releases/download/v1.0.144/officecli-mac-arm64";
          hash = "sha256-BHVxY0KMW96Nkej4OFF4GOdHIhV3IspfOHe2cWt3vUU=";
        };
      };
    in
    binaries.${pkgs.stdenv.hostPlatform.system}
      or (throw "Unsupported system for officecli: ${pkgs.stdenv.hostPlatform.system}");

  # Fetch the @vscode/ripgrep npm package
  vscodeRipgrep = fetchzip {
    url = "https://registry.npmjs.org/@vscode/ripgrep/-/ripgrep-1.17.1.tgz";
    hash = "sha256-tRnAUK4wTxRhYl7ZIkIEIjFCmiCSIMyE7guCEjbXBDI=";
    stripRoot = false;
  };

  # Platform-specific ripgrep binary for @vscode/ripgrep
  vscodeRipgrepBinary =
    let
      sources = {
        "x86_64-linux" = fetchzip {
          url = "https://github.com/microsoft/ripgrep-prebuilt/releases/download/v15.0.1/ripgrep-v15.0.1-x86_64-unknown-linux-musl.tar.gz";
          hash = "sha256-lFLt8/eUPYlJgIFG2mBrpTV2L2+JSOEU1BBOMrmzeQU=";
          stripRoot = false;
        };
        "aarch64-linux" = fetchzip {
          url = "https://github.com/microsoft/ripgrep-prebuilt/releases/download/v15.0.1/ripgrep-v15.0.1-aarch64-unknown-linux-musl.tar.gz";
          hash = "sha256-3Tc4pLbo3w+zvD7cWvNSxMOeDZetEYoj5Rdr3F1Iugg=";
          stripRoot = false;
        };
        "x86_64-darwin" = fetchzip {
          url = "https://github.com/microsoft/ripgrep-prebuilt/releases/download/v15.0.1/ripgrep-v15.0.1-x86_64-apple-darwin.tar.gz";
          hash = "sha256-WRxpPoC7RE7xkHsqkG/rnHe8r+HN9QkQfMddzw6HW9I=";
          stripRoot = false;
        };
        "aarch64-darwin" = fetchzip {
          url = "https://github.com/microsoft/ripgrep-prebuilt/releases/download/v15.0.1/ripgrep-v15.0.1-aarch64-apple-darwin.tar.gz";
          hash = "sha256-L6FkZP2GOFiKZ8f8Fy08S1f73GXf82bhCwsOkHNGKKY=";
          stripRoot = false;
        };
      };
    in
    sources.${pkgs.stdenv.hostPlatform.system}
      or (throw "Unsupported system for vscode-ripgrep: ${pkgs.stdenv.hostPlatform.system}");
in
pkgs.stdenv.mkDerivation rec {
  pname = "bobshell";
  version = "2.0.5";

  src = fetchurl {
    url = "https://s3.us-south.cloud-object-storage.appdomain.cloud/bob-shell/bobshell-${version}.tgz";
    sha256 = "sha256-7/Iy6xtp80+YTd0pXmlgRwBYypIrHHUYecWo0GGZ9WY=";
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
    cp -r ${nodePtyPlatform.src}/package node_modules/@lydell/${nodePtyPlatform.pkgName}

    mkdir -p node_modules/@officecli/officecli/vendor
    cp -r ${officecli}/package/* node_modules/@officecli/officecli/
    cp ${officecliBinary} node_modules/@officecli/officecli/vendor/officecli
    chmod +x node_modules/@officecli/officecli/vendor/officecli

    mkdir -p node_modules/@vscode/ripgrep/bin
    cp -r ${vscodeRipgrep}/package/* node_modules/@vscode/ripgrep/
    cp ${vscodeRipgrepBinary}/rg node_modules/@vscode/ripgrep/bin/rg
    chmod +x node_modules/@vscode/ripgrep/bin/rg

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
