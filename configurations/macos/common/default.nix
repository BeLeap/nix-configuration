{
  metadata,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./brew.nix
  ];

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
}
