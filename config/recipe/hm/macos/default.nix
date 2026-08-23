{inputs, ...}: {
  darwin = {
    system = [
      (_: {
        imports = [inputs.home-manager.darwinModules.home-manager];
      })
    ];
    home = [
      (_: {
        imports = [./module.nix];
      })
    ];
  };
}
