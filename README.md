# dotfiles

My ever-changing dotfiles repo.

## Nix Config

### Initial Setup for new system

Clone this repo into your `~/.dotfiles` directory.
Note that this flake is impure, because it does reference absolute path of the neovim subdirectory here, in order to use `mkOutOfStoreSymlink` to symlink neovim config to this folder.

When starting up a new system, you may not find `home-manager` or `nh` commands available, so try

```shell
nix shell nixpkgs#home-manager nixpkgs#nh nixpkgs#git nixpkgs#vim
```

All the NixOs and home-manager build outputs are defined in [./flake.nix](./flake.nix).
There, create new host/home-manager build outputs if needed.

Then, rebuild boot (example here for `dell-wsl-nixos` host).
(WSL note: see [this link](https://nix-community.github.io/NixOS-WSL/how-to/change-username.html) for warnings on changing username)

```shell
sudo nixos-rebuild boot --flake .#dell-wsl-nixos
```

Then restart, and `nh` should be available.

### Switching

I'm using [nh](https://github.com/viperML/nh) (nix helper).
The flake path to this dotfile repo is set in the os config files (eg [./hosts/laptop/configuration.nix](./hosts/laptop/configuration.nix)), so you don't need to be in the dotfiles folder to execute the commands below.
Also, `nh` by default uses `user@hostname` for the targets, so you also don't have to specify the targets, the following command should work as is on any of my systems.

To update NixOS

```shell
nh os switch
```

For WSL instance, need to pass `--impure` flag, since the config references a folder in the `/mnt/c/` mount.

```shell
nh os switch -- --impure
```

To update home-manager

```shell
nh home switch
```

After home-manager switch, you may have to reload the shell with `exec $SHELL -l`, which I've aliased as `reload`.

Use the following to upgrade the flake, which you should do periodically.

```shell
nix flake update
```

## Browser Extension Settings

Yomitan and asbplayer keep their settings in `chrome.storage.local`, and neither
declares a `managed_schema`, so Chromium's enterprise policy can't seed them.
Instead, [./modules/features/browser-extensions](./modules/features/browser-extensions)
version-controls each extension's own backup file and symlinks it into `$HOME`.

Enable it per-host with `myHomeManager.browser-extensions.enable = true;`.

### Restoring on a new system

After Chromium has installed the extensions, import from the settings page:

| Extension | Where | File |
| --- | --- | --- |
| Yomitan | settings -> Backup -> Import Settings | `~/yomitan-settings.json` |
| asbplayer | options -> Import Settings | `~/asbplayer-settings.json` |

Yomitan dictionaries live in IndexedDB and are **not** part of the settings
backup -- it only references them by name. Re-import the dictionary zips, or use
Yomitan's Export/Import Dictionary buttons, or the restored profile will point at
dictionaries that aren't installed.

### Saving changes back

The files are `mkOutOfStoreSymlink`s, so exporting over the symlinked path writes
straight back into this repo and `git diff` shows what changed.

```shell
git diff modules/features/browser-extensions
```

### Adding a new extension

Drop the exported JSON next to the module as `<name>-settings.json` and add a
`linkIfPresent "<name>-settings.json"` to `home.file`.

Two gotchas, both of which fail silently:

- The file must be **git-tracked**. The module tests existence against `./.` (the
  store copy of the module directory), and flakes only copy tracked files into
  the store, so an untracked export is invisible.
- That existence check must stay on `./.` rather than `config.mynixos.dotfilesPath`.
  A path outside the store reads as missing under pure evaluation, and since
  `nh home switch` evaluates pure by default, checking the out-of-store path drops
  every file in the module and reports "No version or size changes".

## Neovim

See [my neovim setup](./modules/features/neovim/README.md)
