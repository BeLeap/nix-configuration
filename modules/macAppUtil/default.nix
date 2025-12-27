{ metadata, mac-app-util, ... }:
if (metadata.os == "darwin") then
  [
    mac-app-util.darwinModules.default
    {
      home-manager.sharedModules = [
        mac-app-util.homeManagerModules.default
      ];
    }
  ]
else
  [ ]
