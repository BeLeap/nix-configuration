_: {
  hm = [
    (
      _: {
        programs.fzf = {
          enable = true;

          enableZshIntegration = true;
          enableBashIntegration = true;
          enableNushellIntegration = true;
        };
      }
    )
  ];
}
