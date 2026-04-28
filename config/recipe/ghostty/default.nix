{metadata}: {
  hm = [
    ({
      pkgs,
      lib,
      ...
    }: {
      programs.ghostty = {
        enable = true;
        package =
          if (metadata.os == "darwin")
          then pkgs.ghostty-bin
          else pkgs.ghostty;

        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;

        settings = {
          theme = "Catppuccin Mocha";

          font-family = "Hack Nerd Font Mono";
          font-size = 16;

          notify-on-command-finish = "unfocused";
          notify-on-command-finish-action = "no-bell,notify";

          window-padding-x = 8;
          window-padding-y = 4;

          initial-command = "${lib.getExe pkgs.zsh} -l -i -c \"${lib.getExe pkgs.tmux} new-session -As scratchpad\"";
        };
      };
    })
  ];
}
