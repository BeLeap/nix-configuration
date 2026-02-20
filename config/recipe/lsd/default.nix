_: {
  hm = [
    (
      _: {
        programs.lsd = {
          enable = true;

          enableZshIntegration = true;
          enableBashIntegration = true;
        };
      }
    )
  ];
}
