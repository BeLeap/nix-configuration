_: {
  hm = [
    ({
      lib,
      pkgs,
      ...
    }: let
      ghosttyPackage =
        if pkgs.stdenv.hostPlatform.isDarwin
        then pkgs.ghostty-bin
        else pkgs.ghostty;
    in {
      programs.ghostty = {
        enable = true;
        package = ghosttyPackage;

        settings = {
          theme = "Gruvbox Dark";
          font-family = "CaskaydiaCove Nerd Font Mono";
          font-size = 16;
          background-opacity = 0.8;
          window-padding-x = 8;
          window-decoration = false;
          command = "${lib.getExe pkgs.zsh} -l -i -c 'exec ${lib.getExe pkgs.tmux} new-session -As sp'";
        };
      };
    })
  ];
}
