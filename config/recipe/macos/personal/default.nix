_: {
  base = {pkgs, ...}: {
    homebrew = {
      casks = [
        "logseq"
        "tailscale-app"
      ];
      masApps = {
        KakaoTalk = 869223134;
      };
    };

    system.defaults.dock.persistent-apps = [
      {app = "${pkgs.discord}/Applications/Discord.app";}
      {app = "${pkgs.joplin-desktop}/Applications/Joplin.app";}
      {app = "${pkgs.google-messages}/Applications/Messages.app";}
    ];
  };
}
