{inputs, ...}: {
  system = [
    ({
      inputs,
      host,
      ...
    }: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = {inherit inputs host;};
      };
    })
  ];

  darwin = {
    system = [
      (_: {
        imports = [inputs.home-manager.darwinModules.home-manager];
      })
    ];
    home = [
      (
        {
          pkgs,
          host,
          ...
        }: {
          imports = [./common.nix];

          home = {
            packages = with pkgs; [
              mas
            ];

            homeDirectory = "/Users/${host.usernameLower}";

            file.".config/nixpkgs/config.nix".text = ''
              {
                allowUnfree = true;
                android_sdk.accept_license = true;
              }
            '';
          };
        }
      )
    ];
  };

  nixos = {
    system = [
      (_: {
        imports = [inputs.home-manager.nixosModules.home-manager];
      })
    ];
    home = [
      (_: {
        imports = [./common.nix];

        home.packages = [];

        xdg.enable = true;
        xdg.userDirs.enable = true;
      })
    ];
  };
}
