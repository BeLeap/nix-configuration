_: {
  includes = [
    "joplin"
    "syncthing"
    "keepassxc"
    "discord"
  ];
  home = [
    ({pkgs, ...}: {
      programs.firefox.profiles."beleap".extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        joplin-web-clipper
        keepassxc-browser
      ];
    })
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
    home = [
      ({pkgs, ...}: {
        home.packages = [
          pkgs.unstable.betterdisplay
          pkgs.minute
        ];
      })
    ];
  };
}
