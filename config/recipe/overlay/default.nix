{inputs, ...}: {
  system = [
    (_: {
      nixpkgs.overlays = import ./overlays.nix {inherit inputs;};
    })
  ];
}
