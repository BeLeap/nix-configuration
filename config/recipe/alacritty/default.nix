_: {
  hm = [
    ({
      lib,
      pkgs,
      ...
    }: {
      programs.alacritty = {
        enable = true;

        theme = "catppuccin_mocha";
        settings = {
          font = {
            normal = {family = "Hack Nerd Font Mono";};
            size = 16;
          };
          window = {
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
