_: {
  nixos = {
    system = [
      (_: {
        nix.gc.dates = "weekly";
      })
    ];
  };
}
