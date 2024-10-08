username := "parkin"
hostname := "galacticboi-nixos"
hostname-wsl := "wsl-nixos"

home-switch-galacticboi:
  home-manager switch --flake .#{{username}}@{{hostname}}

home-switch-wsl:
  home-manager switch --flake .#{{username}}@{{hostname-wsl}}

nixos-switch-galacticboi:
  sudo nixos-rebuild switch --flake .#{{hostname}}
