_: {
  nix.optimise.automatic = true;

  nixpkgs = {
    config.allowUnfree = true;
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
}
