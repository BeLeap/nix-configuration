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
  callPackage = lib.callPackageWith (inputs);
  specialArgs = { inherit inputs metadata; };
  modules =
    (map (p: (./. + "/modules/${p}")) [
      "overlay"
      "hmDefaultOptions"
    ])
    ++ lib.flatten (
      lib.map (p: (callPackage (./. + "/modules/${p}") { })) [
        "macAppUtil"
      ]
    )
    ++ [
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
