{
  lib,
  metadata,
}: {
  base = {
    pkgs,
    inputs,
    ...
  }: {
    environment.systemPackages = [];

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";

    homebrew = {
      enable = metadata.kind != "airgap";

      onActivation = {
        cleanup = "zap";
        extraFlags = ["--verbose"];
      };

      taps = [];
      brews = ["mas"];
      casks =
        [
          "meetingbar"
          "karabiner-elements"
          "wireshark-chmodbpf"
          "gureumkim"
        ]
        ++ (lib.optionals (metadata.kind == "personal") [
          "logseq"
          "tailscale-app"
        ]);
      masApps =
        {}
        // (lib.optionalAttrs (metadata.kind == "personal") {
          KakaoTalk = 869223134;
        });
    };

    system = {
      # Set Git commit hash for darwin-version.
      configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      stateVersion = 6;

      keyboard = {
        enableKeyMapping = true;
        nonUS.remapTilde = false;
      };

      defaults = {
        dock.autohide = true;

        dock.persistent-apps =
          [
            {app = "${pkgs.ghostty-bin}/Applications/Ghostty.app";}
            {app = "${pkgs.firefox}/Applications/Firefox.app";}
            {app = "${pkgs.wireshark}/Applications/Wireshark.app";}
          ]
          ++ (lib.optionals (metadata.kind == "personal") [
            {app = "${pkgs.discord}/Applications/Discord.app";}
            {app = "${pkgs.joplin-desktop}/Applications/Joplin.app";}
            {app = "${pkgs.google-messages}/Applications/Messages.app";}
          ])
          ++ (lib.optionals (metadata.kind == "work") [
            {app = "/Applications/IntelliJ IDEA.app";}
            {app = "/Applications/DataGrip.app";}
          ]);

        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;

          NewWindowTarget = "Other";

          ShowStatusBar = true;
          ShowPathbar = true;
          NewWindowTargetPath = "file:///Users/${metadata.usernameLower}";
        };

        screencapture = {
          target = "clipboard";
          show-thumbnail = true;
        };
      };
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    system.primaryUser = metadata.usernameLower;
    users.users."${metadata.usernameLower}" = {
      home = "/Users/${metadata.usernameLower}";
    };
  };
  hm = [
    (_: {
      home.sessionPath = [
        "/opt/homebrew/bin"
      ];

      launchd.agents.set-wallpaper = {
        enable = true;
        config = {
          Label = "dev.beleap.set-wallpaper";
          ProgramArguments = [
            "/usr/bin/osascript"
            "-e"
            "tell application \"System Events\""
            "-e"
            "set picture of every desktop to POSIX file \"${../../../files/apple-colors-small-4k.png}\""
            "-e"
            "end tell"
          ];
          RunAtLoad = true;
          StartInterval = 300;
          StandardOutPath = "/tmp/set-wallpaper.out.log";
          StandardErrorPath = "/tmp/set-wallpaper.err.log";
        };
      };
    })
  ];
}
