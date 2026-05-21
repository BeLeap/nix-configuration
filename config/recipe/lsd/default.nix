_: {
  hm = [
    (
      _: {
        programs.lsd = {
          enable = true;

          enableZshIntegration = false;
          enableBashIntegration = false;
          enableFishIntegration = false;
        };
        home.shellAliases = {
          ls = "lsd";
          ll = "lsd -l";
          lla = "lsd -la";
          lt = "lsd -t";
        };
      }
    )
  ];
}
