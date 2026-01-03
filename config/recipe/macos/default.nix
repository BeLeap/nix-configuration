{
  lib,
  metadata,
}:
(lib.optionalAttrs (metadata.distribution == "macos") {
  base =
    { pkgs, inputs, ... }:
    {
      environment.systemPackages = [ ];

      # Set Git commit hash for darwin-version.
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      homebrew = {
        enable = !(metadata.kind == "airgap");

        onActivation = {
          cleanup = "zap";
          extraFlags = [ "--verbose" ];
        };

        taps = [ ];
        brews = [ "mas" ];
        casks = [
          "meetingbar"
          "karabiner-elements"
          "wireshark-chmodbpf"
        ]
        ++ (lib.optionals (metadata.kind == "personal") [
          "logseq"
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
  hm = {
    imports = [ ./home.nix ];
  };
})
