username := "parkin"
hostname := "galacticboi-nixos"

home-switch-galacticboi:
  home-manager switch --flake .#{{username}}@{{hostname}}
  exec $SHELL -l

nixos-switch-galacticboi:
  sudo nixos-rebuild switch --flake .#{{hostname}}
