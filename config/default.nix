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
  recursiveImport =
    p:
    let
      recipe = importRecipe p;
      innerRecipe = map importRecipe (get recipe "recipes" [ ]);
    in
    [ recipe ] ++ innerRecipe;

  # handle recipes
  targets = lib.flatten (map recursiveImport recipes);
in
lib.flatten ((map (c: get c "base" [ ]) targets))
++ lib.flatten (
  map (
    c:
    map (hm: {
      home-manager.users."${metadata.usernameLower}" = hm;
    }) (get c "hm" [ ])
  ) targets
)
