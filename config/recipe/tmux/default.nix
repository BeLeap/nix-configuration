_: {
  hm = [
    ({
      lib,
      pkgs,
      ...
    }: {
      programs.tmux = {
        enable = true;

        shortcut = "a";
        sensibleOnTop = true;
        keyMode = "vi";
        terminal = "tmux-256color";
        mouse = false;
        baseIndex = 1;
        escapeTime = 0;
        aggressiveResize = true;

        plugins = [
          {
            extraConfig = ''
              set -g @tmux-gruvbox 'dark'
            '';
            plugin = pkgs.tmuxPlugins.gruvbox;
          }
        ];

        extraConfig = ''
          set -g default-shell ${lib.getExe pkgs.bashInteractive}
          set -g default-command "shopt -s execfail; exec ${lib.getExe pkgs.zsh} -l; exec ${lib.getExe pkgs.bashInteractive} --noprofile --norc"

          set -as terminal-features ",xterm-ghostty:RGB"
          set -as terminal-features ",xterm-ghostty:extkeys"
          set -as terminal-features ",xterm-ghostty:clipboard"

          set -g allow-passthrough all
          set -g set-clipboard on

          # The Gruvbox plugin uses Powerline separators by default; keep its
          # palette but use plain status formats that work with non-patched fonts.
          set -g status-left '[#S] '
          set -g status-right '%Y-%m-%d %H:%M #h'
          setw -g window-status-current-format ' #I:#W* '
          setw -g window-status-format ' #I:#W '
          setw -g window-status-separator ' '

          bind  c  new-window      -c "#{pane_current_path}"
          bind  %  split-window -h -c "#{pane_current_path}"
          bind '"' split-window -v -c "#{pane_current_path}"

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi y send-keys -X copy-selection

          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          bind r source-file ~/.config/tmux/tmux.conf
        '';
      };
    })
  ];
}
