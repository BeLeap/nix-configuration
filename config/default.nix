{
  inputs,
  recipes,
}:
let
  # base
  lib = inputs.lib;
  metadata = inputs.metadata;
  callPackage = lib.callPackageWith (inputs);

  # utils
  get =
    a: k: e:
    if (builtins.elem k (builtins.attrNames a)) then a."${k}" else e;

  importRecipe = p: (callPackage (./. + "/recipe/${p}") { });

  # handle recipes
  targets = map importRecipe recipes;
  tn = targets ++ (map importRecipe (lib.flatten (map (t: get t "recipes" [ ]) targets)));
in
lib.flatten ((map (c: get c "base" [ ]) tn))
++ lib.flatten (
  map (
    c:
    map (hm: {
      home-manager.users."${metadata.usernameLower}" = hm;
    }) (get c "hm" [ ])
  ) tn
)
