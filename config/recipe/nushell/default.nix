_: {
  homeModules = [
    (
      _: {
        programs.nushell = {
          enable = true;
        };
      }
    )
  ];
}
