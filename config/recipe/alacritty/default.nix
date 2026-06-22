_: {
  hm = [
    ({
      lib,
      pkgs,
      ...
    }: {
      programs.alacritty = {
        enable = true;

        theme = "gruvbox_dark";
        settings = {
          font = {
            normal = {family = "CaskaydiaCove Nerd Font Mono";};
            size = 16;
          };
          window = {
            opacity = 0.8;
            decorations = "None";
            padding = {
              x = 8;
              y = 8;
            };
          };
          terminal = {
            shell = {
              program = "${lib.getExe pkgs.zsh}";
              args = [
                "-l"
                "-i"
                "-c"
                "exec ${lib.getExe pkgs.tmux} new-session -As sp"
              ];
            };
          };
        };
      };
    })
  ];
}
