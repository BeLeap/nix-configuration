_: {
  includes = [
    "1password"
    "joplin"
    "syncthing"
    "discord"
    "yubikey"
  ];
  home = [
    ({pkgs, ...}: {
      programs.firefox.profiles."beleap".extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        joplin-web-clipper
        onepassword-password-manager
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
        ];
      })
    ];
    home = [
      ({pkgs, ...}: {
        home.packages = [
          pkgs.unstable.betterdisplay
          pkgs.element-desktop
          pkgs.minute
        ];
      })
    ];
  };
}
