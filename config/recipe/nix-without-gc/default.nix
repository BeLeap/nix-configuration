_: {
  includes = [
    "nix"
  ];
  darwin = {
    system = [
      (_: {
        nix.gc.automatic = false;
      })
    ];
  };
}
