{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ## wget - needed for vscode-server
    wget

    ## vscode-extensions - they seem to be handled manually by vscode-server, so don't need here?
    # vscode-extensions.ms-python.black-formatter
    # vscode-extensions.ms-python.debugpy
    # vscode-extensions.ms-python.python
    # vscode-extensions.ms-python.isort
    # vscode-extensions.ms-python.vscode-pylance
    # vscode-extensions.ms-toolsai.datawrangler
    # vscode-extensions.ms-toolsai.jupyter
    # vscode-extensions.ms-toolsai.jupyter-renderers
    # vscode-extensions.ms-toolsai.vscode-jupyter-cell-tags
    # vscode-extensions.ms-toolsai.vscode-jupyter-slideshow
    # vscode-extensions.tamasfe.even-better-toml
    # mechatroner.rainbow-csv
  ];

  home.file = {
    # this file is needed to patch vscode-server to run on WSL NixOS
    # see for details https://github.com/sonowz/vscode-remote-wsl-nixos/blob/master/server-env-setup
    ".vscode-server/server-env-setup".source = ./server-env-setup;
  };

}
