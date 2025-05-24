{
  pkgs,
  config,
  ...
}:
let
  homeManagerSessionVars = "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh";
in
{
  imports = [ ./base.nix ];

  config = {
    # set default shell to zsh
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    # NOTE: potential workaround for sessionVariables setting not working with home manager
    # https://github.com/nix-community/home-manager/issues/1011
    environment.extraInit = "[[ -f ${homeManagerSessionVars} ]] && source ${homeManagerSessionVars}";

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = config.mynixos.dotfilesPath;
    };

  };
}
