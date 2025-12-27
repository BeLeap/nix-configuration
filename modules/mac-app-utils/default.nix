{
  lib,
  mac-app-util,
  metadata,
  ...
}:
lib.optionals (metadata.os == "darwin") [
  mac-app-util.darwinModules.default
  {
    home-manager.sharedModules = [
      mac-app-util.homeManagerModules.default
    ];
  }
]
