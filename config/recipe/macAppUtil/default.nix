{mac-app-util}: {
  base = [
    mac-app-util.darwinModules.default
    {
      home-manager.sharedModules = [
        mac-app-util.homeManagerModules.default
      ];
    }
  ];
}
