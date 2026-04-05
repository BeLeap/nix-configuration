{
  lib,
  callPackage,
  metadatas,
}:
lib.fold
(metadata: acc: let
  recipes = metadata.recipes;
  system = callPackage ./mkSystem.nix {inherit metadata recipes;};
in {
  nixosConfigurations = acc.nixosConfigurations // system.nixosConfigurations;
  darwinConfigurations = acc.darwinConfigurations // system.darwinConfigurations;
})
{
  nixosConfigurations = {};
  darwinConfigurations = {};
}
metadatas
