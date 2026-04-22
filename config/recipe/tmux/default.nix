_: {
  hm = [
    ({pkgs, ...}: {
      programs.tmux = {
        enable = true;

        shortcut = "a";
        sensibleOnTop = true;
        keyMode = "vi";
        terminal = "tmux-256color";
        baseIndex = 1;
        escapeTime = 10;
        aggressiveResize = true;

        plugins = [
          {
            extraConfig = ''
              set -g @catppuccin_flavor 'mocha'
            '';
            plugin = pkgs.tmuxPlugins.catppuccin;
          }
        ];

        extraConfig = ''
          set -g allow-passthrough all

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
