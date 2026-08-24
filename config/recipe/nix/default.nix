_: {
  system = [
    (_: {
      nix = {
        optimise.automatic = true;

        settings = {
          trusted-users = ["@admin"];
          experimental-features = "nix-command flakes";
          min-free = "1M";
          accept-flake-config = true;

          extra-substituters = [
            "https://nix-community.cachix.org"
            "https://cache.numtide.com"
            "https://beleap-nix-overlay.cachix.org"
          ];
          extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            "beleap-nix-overlay.cachix.org-1:SJdfYkwp5t+YoeraOtUcqyKIxvnWQ1GdiNoC21F+En0="
          ];
        };

        gc = {};
      };

      nixpkgs = {
        config.allowUnfree = true;
        config.android_sdk.accept_license = true;
      };
    })
  ];

  darwin = {
    system = [
      (_: {
        nix = {
          gc = {
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
        };
      })
    ];
  };

  nixos = {
    system = [
      (_: {
        nix.gc.dates = "weekly";
      })
    ];
  };
}
