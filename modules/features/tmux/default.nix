{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    myHomeManager.tmux.enable = lib.mkEnableOption "Enables tmux";
  };
  config = lib.mkIf config.myHomeManager.tmux.enable {

    programs.tmux = {
      enable = true;
      shortcut = "a";
      baseIndex = 1;
      keyMode = "vi";
      mouse = true;
      terminal = "tmux-256color";
      plugins = with pkgs.tmuxPlugins; [
        yank
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour "mocha"
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_window_status_style "rounded"
            set -g @catppuccin_date_time "%H:%M"

            # Make the status line pretty and add some modules
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left ""
            set -g status-right "#{E:@catppuccin_status_application}"
            set -ag status-right "#{E:@catppuccin_status_session}"

            # window status look and feel
            set -g allow-rename off
            set -g @catppuccin_window_default_text '#W'
            set -g @catppuccin_window_current_text '#W'
          '';

        }
        {
          plugin = resurrect;
          extraConfig = ''
            # set -g @resurrect-strategy-vim "session"
            # set -g @resurrect-strategy-nvim "session"
            set -g @resurrect-capture-pane-contents "on"
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore "on"
            # set -g @continuum-boot "on" # removing, maybe this is causing blank resurrect file after reboot? not sure
            set -g @continuum-save-interval "10"
          '';
        }
      ];
      extraConfig = (builtins.readFile ./.tmux.conf);
    };
  };
}
