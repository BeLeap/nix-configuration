{inputs, ...}: {
  systemModules = [
    inputs.mac-app-util.darwinModules.default
    (_: {
      home-manager.sharedModules = [
        inputs.mac-app-util.homeManagerModules.default
      ];
    })
  ];
}
