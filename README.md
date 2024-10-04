# dotfiles

Clone this repo into your `~/.dotfiles` directory.

This flake is set up run as `home-manager`.
So to run `home-manager switch`, the first time we need to run

```shell
nix run . -- switch --flake .
```

This will install `home-manager` if not already installed.

After this, we can run `home-manager swtch` using

```shell
home-manager switch --flake .
```

After switching, you may have to run `exec $SHELL -l`, which I've aliased as `reload`.

Use the following to upgrade the flake

```shell
nix flake update
```
