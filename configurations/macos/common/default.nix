{ metadata, pkgs, ... }:
{
  imports = [
    ./brew.nix
  ];

  system.defaults = {
    dock.autohide = true;

    dock.persistent-apps = [
      "/Applications/Firefox Developer Edition.app"
      { app = "${pkgs.wezterm}/Applications/WezTerm.app"; }
    ];

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;

      NewWindowTarget = "Other";

      ShowStatusBar = true;
      NewWindowTargetPath = "file:///Users/${metadata.usernameLower}";
    };

    screencapture = {
      target = "clipboard";
      show-thumbnail = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = metadata.usernameLower;
  users.users."${metadata.usernameLower}" = {
    home = "/Users/${metadata.usernameLower}";
    shell = pkgs.zsh;
  };

  nix.gc = {
    automatic = true;
    interval = [
      {
        Hour = 3;
        Minute = 15;
        Weekday = 7;
      }
    ];
    options = "--delete-older-than 3d";
  };
  nix.settings = {
    trusted-users = [ "@admin" ];
  };

  nix.linux-builder = {
    enable = true;

    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 64 * 1024;
        };
      };
    };
  };

  services.tailscale = {
    enable = metadata.kind == "personal";
    overrideLocalDns = true;
  };
}
