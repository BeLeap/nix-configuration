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
          terminal = {
            shell = {
              program = "${lib.getExe pkgs.zsh}";
              args = [
                "-l"
                "-i"
                "-c"
                "${lib.getExe pkgs.tmux} new-session -As sp"
              ];
            };
          };
        };
      };
    })
  ];
}
