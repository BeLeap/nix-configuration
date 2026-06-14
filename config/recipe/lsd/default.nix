_: {
  hm = [
    (
      _: {
        programs.lsd = {
          enable = true;
        };
        home.shellAliases = {
          ls = "lsd";
          ll = "lsd -l";
          lla = "lsd -la";
          lt = "lsd -lt";
        };
      }
    )
  ];
}
