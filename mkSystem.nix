inputs@{
  lib,
  metadata,

  nixpkgs,
  nixpkgs-unstable,

  nix-darwin,

  home-manager,

  kubectl-check,
  boda,
}:
let
  specialArgs = { inherit inputs metadata; };
  modules = [
    {
      nixpkgs.overlays = [
        (import ./pkgs/overlay.nix {
          inherit (inputs) kubectl-check boda;
        })
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system config;
          };
        })
      ];
    }
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
