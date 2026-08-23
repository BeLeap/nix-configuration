{home-manager, ...}: {
  systemModules = [
    (_: {
      imports = [home-manager.darwinModules.home-manager];
    })
  ];

  homeModules = [
    (_: {
      imports = [./module.nix];
    })
  ];
}
