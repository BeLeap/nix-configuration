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
      };
    })
  ];
}
