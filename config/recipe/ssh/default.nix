_: {
  hm = [
    (
      _: {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;

          matchBlocks = {
            "*" = {};
          };
        };
      }
    )
  ];
}
