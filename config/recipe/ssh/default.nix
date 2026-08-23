_: {
  homeModules = [
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
