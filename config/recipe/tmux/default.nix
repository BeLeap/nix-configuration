_: {
  hm = [
    ({pkgs, ...}: {
      programs.tmux = {
        enable = true;

        shortcut = "a";
        sensibleOnTop = true;
        keyMode = "vi";
        terminal = "screen-256color";
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
        '';
      };
    })
  ];
}
