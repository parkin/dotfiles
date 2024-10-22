# dotfiles

## Initial Setup

Clone this repo into your `~/.dotfiles` directory.
Note that this flake is impure, because it does reference absolute path of the neovim subdirectory here, in order to use `mkOutOfStoreSymlink` to symlink neovim config to this folder.

If you don't see `home-manager` command available, try

```shell
nix shell nixpkgs#home-manager
```

## Normal usage

First, we need the build deps defined in [./flake.nix](./flake.nix) (eg `just`), so start the develop shell with

```shell
nix develop
```

After this, we can run `home-manager swtch` using

```shell
just home home-switch-galacticboi
```

See [justfile](./justfile) for aliases.

After switching, you may have to run `exec $SHELL -l`, which I've aliased as `reload`.

Use the following to upgrade the flake.

```shell
nix flake update
```

## Neovim

See [my neovim setup](./modules/features/neovim/README.md)
