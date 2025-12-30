{ lib, metadata }:
(lib.optinalAttrs (metadata.distribution == "macos") {
  base =
    { pkgs, ... }:
    {
      homebrew = {
        enable = !(metadata.kind == "airgap");

        onActivation = {
          cleanup = "zap";
          extraFlags = [ "--verbose" ];
        };

        taps = [ ];
        brews = [ ];
        casks = [
          "meetingbar"
          "karabiner-elements"
          "wireshark-chmodbpf"
        ]
        ++ (lib.optionals (metadata.kind == "personal") [
          "logseq"
          "1password"
          "tailscale-app"
        ]);
        masApps =
          { }
          // (lib.optionalAttrs (metadata.kind == "personal") {
            KakaoTalk = 869223134;
          });
      };

      system = {
        keyboard = {
          enableKeyMapping = true;
          nonUS.remapTilde = false;
        };

        defaults = {

          dock.autohide = true;

          dock.persistent-apps = [
            "/Applications/Firefox Developer Edition.app"
            { app = "${pkgs.wezterm}/Applications/WezTerm.app"; }
            { app = "${pkgs.wireshark}/Applications/Wireshark.app"; }
          ]
          ++ (lib.optionals (metadata.kind == "personal") [
            { app = "${pkgs.discord}/Applications/Discord.app"; }
            "/Applications/Logseq.app"
          ])
          ++ (lib.optionals (metadata.kind == "work") [
            { app = "/Applications/IntelliJ IDEA.app"; }
            { app = "/Applications/DataGrip.app"; }
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
        shell = pkgs.zsh;
      };
    };
  hm = { };
})
