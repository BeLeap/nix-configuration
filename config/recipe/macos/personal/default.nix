_: {
  includes = [
    "discord"
  ];

  darwin = {
    system = [
      ({pkgs, ...}: {
        homebrew = {
          casks = [
            "tailscale-app"
          ];
          masApps = {
            KakaoTalk = 869223134;
          };
        };

        system.defaults.dock.persistent-apps = [
          {app = "${pkgs.joplin-desktop}/Applications/Joplin.app";}
          {app = "${pkgs.google-messages}/Applications/Messages.app";}
        ];
      })
    ];
  };
}
