{inputs, ...}: {
  systemModules = [
    (_: {
      imports = [inputs.home-manager.darwinModules.home-manager];
    })
  ];

  homeModules = [
    (_: {
      imports = [./module.nix];
    })
  ];
}
