_: {
  darwin = {
    home = [
      ({pkgs, ...}: {
        home.packages = [
          pkgs.minute
        ];
      })
    ];
  };
}
