inputs@{
  lib,
  metadata,

  nixpkgs,
  nixpkgs-unstable,

  nix-darwin,

  home-manager,
  mac-app-util,

  beleap-overlay,

  kubectl-check,
  boda,
}:
let
  specialArgs = { inherit inputs metadata; };
  modules =
    map (p: (./. + "/modules/${p}")) [
      "overlay"
    ]
    ++ [
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.extraSpecialArgs = { inherit metadata; };
      }
      (./configurations/common)
      (./. + "/configurations/${metadata.distribution}/common")
      (./. + "/configurations/${metadata.distribution}/${metadata.configPath}/configuration.nix")
      (
        {
          nixos = home-manager.nixosModules.home-manager;
          macos = home-manager.darwinModules.home-manager;
        }
        ."${metadata.distribution}"
      )
      ({
        home-manager.users."${metadata.usernameLower}" = ./. + "/home/${metadata.distribution}.nix";
      })
    ]
    ++ (lib.optionals (metadata.os == "darwin") [
      mac-app-util.darwinModules.default
      {
        home-manager.sharedModules = [
          mac-app-util.homeManagerModules.default
        ];
      }
    ])
    ++ metadata.extraModule;
in
{
  nixosConfigurations = lib.optionalAttrs (metadata.distribution == "nixos") {
    "${metadata.name}" = inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs modules;
      system = metadata.platform;
    };
  };
  darwinConfigurations = lib.optionalAttrs (metadata.distribution == "macos") {
    "${metadata.name}" = inputs.nix-darwin.lib.darwinSystem {
      inherit specialArgs modules;
    };
  };
}
