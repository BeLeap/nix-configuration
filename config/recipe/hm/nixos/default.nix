{inputs, ...}: {
  nixos = {
    system = [
      (_: {
        imports = [inputs.home-manager.nixosModules.home-manager];
      })
    ];
    home = [
      (_: {
        imports = [./module.nix];
      })
    ];
  };
}
