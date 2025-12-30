{
  inputs,
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
  recipes = map (p: (callPackage (./. + "/recipe/${p}") { })) [
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
in
lib.flatten (
  (map (c: get c "base" { }) recipes)
  ++ (map (c: { home-manager.users."${metadata.usernameLower}" = (get c "hm" { }); }) recipes)
)
