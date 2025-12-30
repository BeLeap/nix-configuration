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

  # handle recipes
  targets = map (p: (callPackage (./. + "/recipe/${p}") { })) recipes;
in
lib.flatten (
  (map (c: get c "base" { }) targets)
  ++ (map (c: { home-manager.users."${metadata.usernameLower}" = (get c "hm" { }); }) targets)
)
