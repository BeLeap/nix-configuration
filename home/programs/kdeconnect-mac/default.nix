{
  pkgs,
  lib,
  metadata,
  ...
}:
if (metadata.kind == "personal")
then {
  home.packages = [
    pkgs.kdeconnect-mac
  ];

  launchd = {
    agents = {
      kdeconnect-mac = {
        enable = true;
        config = {
          Program = "${pkgs.kdeconnect-mac}/Applications/KDE Connect.app/Contents/MacOS/KDE Connect";
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/kdeconnect-mac.log";
          StandardErrorPath = "/tmp/kdeconnect-mac.err.log";
        };
      };
    };
  };
}
else {}
