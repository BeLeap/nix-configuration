{
  metadata,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
  ]
  ++ map (p: (./. + "/programs/${p}")) [
    "aerospace"
  ];

  home.packages = [ ];

  home.homeDirectory = "/Users/${metadata.usernameLower}";

  launchd = {
    agents = {
      aerospace = {
        enable = true;
        config = {
          Program = "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace";
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/aerospace.log";
          StandardErrorPath = "/tmp/aerospace.err.log";
        };
      };
    };
  };
}
