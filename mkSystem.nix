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
  # TODO: we could remove metadata from specialArgs after migration to configs finishes
  specialArgs = { inherit inputs metadata; };
  recipes = [
    # base setup
    "overlay"
    "hm"
    "macAppUtil"

    # good to share among all hosts
    "base"
    "nix"

    "macos"
    "nixos"

    # others
    "kubernetes"
  ];
  modules =
    (import ./config { inherit inputs recipes; })
    ++ [
      (./. + "/configurations/${metadata.distribution}/${metadata.configPath}/configuration.nix")
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
