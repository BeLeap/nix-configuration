_: {
  darwin = {
    home = [
      ({pkgs, ...}: {
        home.packages = [
          pkgs.unstable.homerow
        ];
      })
    ];
  };
}
