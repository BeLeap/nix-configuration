{mac-app-util}: {
  systemModules = [
    mac-app-util.darwinModules.default
    (_: {
      home-manager.sharedModules = [
        mac-app-util.homeManagerModules.default
      ];
    })
  ];
}
