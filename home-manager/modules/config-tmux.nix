{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    terminal = "tmux-256color";

    extraConfig = ''
      set -s focus-events on

      set -sg exit-empty on

      set -g repeat-time 800
      set -g renumber-windows on
      set -g set-titles on

      set -ga terminal-overrides ",**256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'

      setw -g automatic-rename on

      # Status Bar
      set -g display-panes-time 2000
      set -g display-time 4000
      set -g status-fg "#cdd6f4"
      set -g status-bg "#1e1e2e"
      set -g status-justify centre
      set -g status-left '#[fg=#f9e2af][#S]'
      set -g status-left-length 20
      set -g status-right "#[fg=#f9e2af]%b %d %H:%M "

      # Passthrough
      set -g allow-passthrough on
      set -ga update-environment TERM_PROGRAM
      set -ga update-environment TERM

      # Window List
      setw -g window-status-format '#[fg=#f2cdcd]#I:#W'
      setw -g window-status-current-format '#[fg=#f38ba8,bold]#I:#W'

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      bind -r H resize-pane -L 1
      bind -r J resize-pane -D 1
      bind -r K resize-pane -U 1
      bind -r L resize-pane -R 1

      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
    '';

    plugins = with pkgs; [
      tmuxPlugins.sensible

      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-inerval '30' # minutes
        '';
      }
    ];
  };
}
