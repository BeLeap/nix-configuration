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
      ({pkgs, ...}: {
        homebrew.casks = ["discord"];
        system.defaults.dock.persistent-apps = [
          {app = "/Applications/Discord.app";}
        ];
      })
    ];
  };
}
