_: {
  darwin = {
    system = [
      ({pkgs, ...}: {
        system.defaults.dock.persistent-apps = [
          {app = "${pkgs.unstable.discord}/Applications/Discord.app";}
        ];
      })
    ];
    home = [
      (_: {
        programs.discord = {
          enable = true;
          # Discord is installed above; only manage its settings here.
          package = null;
          settings.SKIP_HOST_UPDATE = true;
        };
      })
    ];
  };
}
