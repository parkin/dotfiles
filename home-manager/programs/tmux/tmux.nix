{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.tmux
  ];

  # copy the config file
  home.file = {
    ".tmux.conf".source = ./.tmux.conf;
  };
}
