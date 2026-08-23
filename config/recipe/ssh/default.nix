_: {
  home = [
    (
      _: {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;

          settings = {
            "*" = {};
          };
        };
      }
    )
  ];
}
