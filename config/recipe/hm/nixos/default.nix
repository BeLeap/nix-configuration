{inputs, ...}: {
  systemModules = [
    (_: {
      imports = [inputs.home-manager.nixosModules.home-manager];
    })
  ];

  homeModules = [
    (_: {
      imports = [./module.nix];
    })
  ];
}
