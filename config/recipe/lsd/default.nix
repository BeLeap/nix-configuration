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
          ll = "lsd -l";
          lla = "lsd -la";
        };
      }
    )
  ];
}
