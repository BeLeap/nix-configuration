_: {
  hm = [
    (
      _: {
        programs.zoxide = {
          enable = true;

          enableZshIntegration = true;
          enableBashIntegration = true;
          enableNushellIntegration = true;
        };
      }
    )
  ];
}
