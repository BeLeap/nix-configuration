{home-manager, ...}: {
  systemModules = [
    (_: {
      imports = [home-manager.nixosModules.home-manager];
    })
  ];

  homeModules = [
    (_: {
      imports = [./module.nix];
    })
  ];
}
