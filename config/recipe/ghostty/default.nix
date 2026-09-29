_: {
  home = [
    ({pkgs, ...}: {
      home.packages = [pkgs.unstable.zmx];
      programs.ghostty = {
        enable = true;
        package =
          if pkgs.stdenv.hostPlatform.isDarwin
          then pkgs.ghostty-bin
          else pkgs.ghostty;

        settings = {
          theme = "Gruvbox Dark";
          font-family = "Hanadia Mono";
          font-size = 14;
        };
      };
    })
  ];
}
