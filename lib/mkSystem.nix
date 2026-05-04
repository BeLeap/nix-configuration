inputs @ {
  lib,
  metadata,
  recipes,
  ...
}: let
  # TODO: we could remove metadata from specialArgs after migration to configs finishes
  specialArgs = {inherit inputs metadata;};
  modules = import ../config/recipe-loader.nix {inherit inputs recipes;};
in {
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
