_: {
  hm = [
    (
      _: {
        programs.carapace = {
          enable = true;

          enableZshIntegration = true;
          enableBashIntegration = true;
          enableNushellIntegration = true;
        };
      }
    )
  ];
}
