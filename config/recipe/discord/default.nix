_: {
  base = {pkgs, ...}: {
    system.defaults.dock.persistent-apps = [
      {app = "${pkgs.unstable.discord}/Applications/Discord.app";}
    ];
  };

  hm = [
    (_: {
      programs.discord = {
        enable = true;
        # Discord is installed above; only manage its settings here.
        package = null;
        settings.SKIP_HOST_UPDATE = true;
      };
    })
  ];
}
