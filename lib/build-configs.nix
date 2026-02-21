{
  lib,
  callPackage,
  metadatas,
  baseRecipes,
}:
lib.fold
(metadata: acc: let
  recipes = baseRecipes ++ metadata.recipes;
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
