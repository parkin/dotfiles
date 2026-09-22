# Galacticboi Nixos

## Syncthing

### Initial Setup

1. NixOS side

Add to configuration.nix:

```nix
services.syncthing = {
  enable = true;
  user = "YOURUSER";
  dataDir = "/home/YOURUSER";          # default folder location
  configDir = "/home/YOURUSER/.config/syncthing";
  openDefaultPorts = true;             # 22000 TCP/UDP, 21027 UDP discovery
};
```

Rebuild, then open the web UI at `http://127.0.0.1:8384`.
Set a GUI username/password under Settings → GUI so other users on the machine can't touch it.

You can also declare devices and folders in Nix (`services.syncthing.settings.devices` / `.folders`), but do the first pairing in the UI since you don't have the phone's ID yet.

2. Android side

Install Syncthing-Fork (F-Droid or Play Store; the original Syncthing Android app was discontinued). Open it, grant storage/notification permissions, and in the Status tab note its Device ID, or use the QR code.

3. Pair the devices

On the laptop web UI: Add Remote Device → paste the phone's ID (or on the phone, Devices → + → scan the laptop's QR code from Actions → Show ID). Give it a name, save. Within a minute the other device shows a "new device wants to connect" prompt — accept it.

Both need to be on the same network for the first connection, or reachable via relay (on by default, encrypted, just slower).

4. Share the vault

On the laptop: Add Folder → path `/home/parkin/git/wiki`, folder label "Obsidian", and under Sharing tick the phone.
On the phone accept the share prompt and pick a local path — use something under `/storage/emulated/0/` like `Documents/wiki`, not the app's private storage, so Obsidian can see it.

Then in Obsidian mobile: Open folder as vault → choose that path.

5. Settings worth changing

- Folder → Advanced → **File Versioning: Staggered** on the laptop.
  Gives you local undo if a bad sync or a phone edit clobbers something.
- On the phone, add `.obsidian/workspace.json` and `.obsidian/workspace-mobile.json` to the folder's ignore patterns (`.stignore`).
  Those files change constantly and cause pointless conflicts.
  Keep the rest of `.obsidian` synced if you want plugins/themes shared, or ignore the whole folder if not.
- Syncthing-Fork → Settings → Run Conditions: default is Wi-Fi + charging. Loosen to "always on Wi-Fi" or allow mobile data if you want faster syncs; the vault is small.
- Battery: exempt Syncthing-Fork from battery optimisation in Android settings or it'll get killed in the background.

6. Check it

Edit a note on the laptop, wait a few seconds, see it on the phone.
If a file was edited on both sides between syncs, Syncthing keeps both and names one `note.sync-conflict-DATE.md` — search for `sync-conflict` occasionally and merge by hand.

## Browser Extension Settings

Yomitan and asbplayer keep their settings in `chrome.storage.local`, and neither
declares a `managed_schema`, so Chromium's enterprise policy can't seed them.
Instead, [./modules/features/browser-extensions](./modules/features/browser-extensions)
version-controls each extension's own backup file and symlinks it into `$HOME`.

Enable it per-host with `myHomeManager.browser-extensions.enable = true;`.

### Restoring on a new system

After Chromium has installed the extensions, import from the settings page:

| Extension | Where                                 | File                        |
| --------- | ------------------------------------- | --------------------------- |
| Yomitan   | settings -> Backup -> Import Settings | `~/yomitan-settings.json`   |
| asbplayer | options -> Import Settings            | `~/asbplayer-settings.json` |

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
