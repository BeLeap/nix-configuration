{
  lib,
  metadata,
  mac-app-util,
}:
{
  base = lib.optionals (metadata.distribution == "macos") [
    mac-app-util.darwinModules.default
    {
      home-manager.sharedModules = [
        mac-app-util.homeManagerModules.default
      ];
    }
  ];
}
