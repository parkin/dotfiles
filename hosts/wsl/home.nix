{
  pkgs,
  config,
  ...
}:
let
  sessionVariables = {
    # Set extra variables for Plotly to render in the Windows browser.
    # see https://plotly.com/python/renderers/
    BROWSER = ''/mnt/c/Program Files/Mozilla Firefox/firefox.exe'';
    PLOTLY_RENDERER = "browser";
    # set WebAgg as default backend for matplotlib
    MPLBACKEND = "webagg";
  };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = config.mynixos.username;
  home.homeDirectory = "/home/${config.mynixos.username}";

  programs.git.userName = "Will Parkin";
  programs.git.userEmail = "parkin@ibm.com";

  programs.bash.sessionVariables = sessionVariables;
  programs.zsh.sessionVariables = sessionVariables;
  # add extra line to auto-launch ssh-agent and use ssh-add for WSL
  # see https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
  programs.zsh.initExtra = ''
    function ssh_start_agent() {
      # start ssh-agent for WSL,
      # see https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows
      env=~/.ssh/agent.env

      agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

      agent_start () {
          (umask 077; ssh-agent >| "$env")
          . "$env" >| /dev/null ; }

      agent_load_env

      # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
      agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

      if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
          agent_start
          ssh-add -t 1h
      elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
          ssh-add -t 1h
      fi

      unset env
    }
  '';

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  imports = [
    # base config
    ../base-hm.nix
    # my config modules
    ../../modules
    # vscode extensions for wsl (Removing for now)
    # ../../modules/features/vscode-wsl/vscode-wsl.nix
  ];

  ## Options for my personal modules.
  ## These options are defined in the modules imported above.
  myHomeManager = {
    bundles.terminal.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    wsl-open
  ];

}
