_: {
  nixos = {
    home = [
      ({pkgs, ...}: {
        home.packages = [pkgs.discord];
      })
    ];
  };
  darwin = {
    system = [
      (_: {
        homebrew.casks = ["discord"];
        system.defaults.dock.persistent-apps = [
          {app = "/Applications/Discord.app";}
        ];
      })
    ];
  };
}
