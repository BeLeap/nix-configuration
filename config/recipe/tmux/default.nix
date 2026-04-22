_: {
  hm = [
    ({pkgs, ...}: {
      programs.tmux = {
        enable = true;

        shortcut = "a";
        sensibleOnTop = true;
        keyMode = "vi";

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
