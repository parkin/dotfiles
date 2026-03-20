# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

NixOS + Home Manager dotfiles flake managing configuration across multiple systems:
- `galacticboi-nixos` — main laptop (GNOME desktop)
- `wsl-nixos` — Lenovo WSL
- `dell-wsl-nixos` — Dell WSL (with GPU/CUDA/Docker Nvidia support)

The flake is **impure** due to `mkOutOfStoreSymlink` usage for neovim config symlinks.

## Common Commands

```shell
# Rebuild NixOS system
nh os switch

# For WSL systems (needs --impure for /mnt/c/ references)
nh os switch -- --impure

# Rebuild home-manager
nh home switch

# Update flake inputs
nix flake update

# Reload shell after home-manager switch
reload
```

## Architecture

### Flake Structure

`flake.nix` defines two helper functions that reduce boilerplate:
- `mkNixOSConfig` — creates NixOS configurations with shared modules and overlays
- `mkHomeConfig` — creates home-manager configurations

Both inject a custom options namespace: `mynixos` (system-level) and `myHomeManager` (home-level), defined in `hosts/base.nix`.

### Hosts

Each host directory under `hosts/` contains OS and home-manager config. Shared base config lives in:
- `hosts/base.nix` — defines custom option types (`mynixos`, `myHomeManager`)
- `hosts/base-os.nix` — common OS settings (zsh default shell, nh, nix experimental features)
- `hosts/base-hm.nix` — common home-manager settings

### Modules

`modules/features/` — individual feature modules, each gated by a `myHomeManager.<feature>.enable` option:
- `neovim/` — LazyVim-based setup with LSP/formatters for multiple languages
- `zsh.nix`, `bash.nix` — shell configs
- `tmux/`, `kitty.nix`, `starship/`, `yazi/`, `zellij/` — terminal tools
- `claude-code/` — Claude Code CLI with custom statusline
- `japanese/` — Japanese input (fcitx5 + Mozc)

`modules/bundles/terminal.nix` — meta-module that enables a curated set of terminal features, defines shared shell aliases, installs fonts, and configures git/direnv/taskeru.

### Config Symlink Strategy

Many modules use `mkOutOfStoreSymlink` to symlink config files directly from this dotfiles directory rather than copying them into the Nix store. This means editing files here (e.g., `modules/features/neovim/nvim/`) immediately affects the running config without rebuilding.

### Nixpkgs Channels

- Stable: `nixpkgs` (nixos-25.11)
- Unstable: `nixos-unstable` overlay selectively applied for specific packages (zellij, claude-code, etc.)
- `allowUnfree = true` is enabled
