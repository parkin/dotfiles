{
  pkgs,
  lib,
  config,
  ...
}:
let
  homeManagerSessionVars = "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
in
{
  options = {
    mynixos.username = lib.mkOption {
      description = "Default username";
      default = "parkin";
      type = lib.types.str;
    };

  };
  config = {
    # set default shell to zsh
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    # NOTE: potential workaround for sessionVariables setting not working with home manager
    # https://github.com/nix-community/home-manager/issues/1011
    environment.extraInit = "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}";

    # enable flake support at os level
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/${config.mynixos.username}/.dotfiles";
    };

  };
}
