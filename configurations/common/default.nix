_: {
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = [
      {
        Hour = 3;
        Minute = 15;
        Weekday = 7;
      }
    ];
    options = "--delete-older-than 3d";
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
}
