# dotfiles

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
