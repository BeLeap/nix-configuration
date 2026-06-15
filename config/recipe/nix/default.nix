_: {
  base = [
    {
      nix = {
        optimise.automatic = true;

        settings = {
          trusted-users = ["@admin"];
          experimental-features = "nix-command flakes";
          min-free = "1M";
          accept-flake-config = true;
        };

        gc = {};
      };

      nixpkgs = {
        config.allowUnfree = true;
        config.android_sdk.accept_license = true;
      };
    }
  ];
}
