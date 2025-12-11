{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    terminal = "tmux-256color";
    historyLimit = 100000;
    keyMode = "vi";
    prefix = "C-a";
    shell = "${pkgs.zsh}/bin/zsh";  # Use zsh instead of default shell

    # Tmux plugins (Nix-managed, no TPM needed)
    plugins = with pkgs.tmuxPlugins; [
      # Dracula theme (primary)
      {
        plugin = dracula;
        extraConfig = ''
          # Dracula theme configuration
          # Explicitly control which plugins show (this prevents network/"redacted" from showing)
          set -g @dracula-plugins "battery weather time"

          # Weather settings
          set -g @dracula-show-fahrenheit false  # Use Celsius instead of Fahrenheit
          set -g @dracula-fixed-location "Toronto"  # Set your Canadian city
          set -g @dracula-show-location false  # Don't show location name

          # Time settings
          set -g @dracula-military-time true  # 24-hour format
          set -g @dracula-day-month true  # Show day/month

          # Left side icon
          set -g @dracula-show-left-icon session
        '';
      }

      # Catppuccin theme (backup/alternative - commented out)
      # Uncomment to use instead of Dracula
      # {
      #   plugin = catppuccin;
      #   extraConfig = ''
      #     set -g @catppuccin_flavour 'mocha'
      #     set -g @catppuccin_window_left_separator ""
      #     set -g @catppuccin_window_right_separator " "
      #     set -g @catppuccin_window_middle_separator " █"
      #     set -g @catppuccin_window_number_position "right"
      #     set -g @catppuccin_window_default_fill "number"
      #     set -g @catppuccin_window_default_text "#W"
      #     set -g @catppuccin_window_current_fill "number"
      #     set -g @catppuccin_window_current_text "#W"
      #     set -g @catppuccin_status_modules_right "directory user host session"
      #     set -g @catppuccin_status_left_separator  " "
      #     set -g @catppuccin_status_right_separator ""
      #     set -g @catppuccin_status_fill "icon"
      #     set -g @catppuccin_status_connect_separator "no"
      #     set -g @catppuccin_directory_text "#{pane_current_path}"
      #   '';
      # }

      # Essential plugins
      sensible              # Sensible defaults
      yank                  # Copy to system clipboard
      vim-tmux-navigator    # Seamless vim/tmux navigation
    ];

    extraConfig = ''
      # Ensure zsh loads properly
      set -g default-command "${pkgs.zsh}/bin/zsh"

      # Status bar at top
      set-option -g status-position top

      # Session management with sesh
      # Sesh will search these directories for projects (space-separated)
      # It also auto-discovers tmuxinator configs
      bind-key "f" run-shell "sesh connect \"$(
        sesh list -i | fzf-tmux -p 55%,60% \
          --no-sort --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list)'
      )\""

      # Unbind default prefix
      unbind C-b
      bind C-a send-prefix

      # Vi mode copy settings
      setw -g mode-keys vi
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi C-v send -X rectangle-toggle

      # Enable clipboard integration (tmux-yank plugin handles the actual copying)
      set -g set-clipboard on

      # Additional copy mode bindings
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel
      bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel

      # Easy way to copy current pane content
      bind -T prefix C-c run-shell 'tmux show-buffer | pbcopy'

      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Pane navigation (prefix + hjkl)
      # Note: C-hjkl handled by vim-tmux-navigator for seamless vim/tmux navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Session management
      bind s choose-tree -Zw

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display 'Config reloaded!'

      # Enable true color support
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -ga terminal-overrides ",alacritty:Tc"

      # Start windows and panes at 1, not 0
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # vim-tmux-navigator integration
      # Smart pane switching with awareness of Vim splits
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';
  };
}
