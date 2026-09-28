_: {
  system = [
    ({pkgs, ...}: {
      environment.systemPackages = [
        (pkgs.runCommand "nix-static-bin" {} ''
          mkdir -p "$out/bin"
          ln -s ${pkgs.nixStatic}/bin/nix "$out/bin/nix-static"
        '')
      ];
    })
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
      ({pkgs, ...}: {
        system.activationScripts.nixStatic.text = ''
          ${pkgs.coreutils}/bin/install -d -m 0755 /usr/local/sbin
          ${pkgs.coreutils}/bin/ln -sfnT ${pkgs.nixStatic}/bin/nix /usr/local/sbin/nix
        '';
      })
    ];
  };

  nixos = {
    system = [
      ({pkgs, ...}: {
        system.activationScripts.nixStatic = ''
          install -d -m 0755 /usr/local/sbin
          ln -sfnT ${pkgs.nixStatic}/bin/nix /usr/local/sbin/nix
        '';
      })
    ];
  };
}
