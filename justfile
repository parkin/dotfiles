username := "parkin"
hostname := "galacticboi-nixos"

home-switch-galacticboi:
  home-manager switch --flake .#{{username}}@{{hostname}}

nixos-switch-galacticboi:
  sudo nixos-rebuild switch --flake .#{{hostname}}
