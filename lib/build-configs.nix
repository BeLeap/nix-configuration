{
  lib,
  callPackage,
  metadatas,
}:
lib.fold
(metadata: acc: let
  system = callPackage ./mkSystem.nix {
    inherit metadata;
    inherit (metadata) recipes;
  };
in {
  nixosConfigurations = acc.nixosConfigurations // system.nixosConfigurations;
  darwinConfigurations = acc.darwinConfigurations // system.darwinConfigurations;
})
{
  nixosConfigurations = {};
  darwinConfigurations = {};
}
metadatas
