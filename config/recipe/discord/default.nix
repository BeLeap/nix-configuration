_: {
  home = [
    (_: {
      programs.discord = {
        enable = true;
        package = null;
        settings.SKIP_HOST_UPDATE = true;
      };
    })
  ];
  darwin = {
    system = [
      ({pkgs, ...}: {
        system.defaults.dock.persistent-apps = [
          {app = "${pkgs.unstable.discord}/Applications/Discord.app";}
        ];
      })
    ];
  };
}
