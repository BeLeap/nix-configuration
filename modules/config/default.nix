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

  # handle configs
  configs = map (p: (callPackage (./. + "/configs/${p}") { })) [
    "common"
    "overlay"
    "hm"
    "macAppUtil"
    "nix"
    "kubernetes"
  ];
in
lib.flatten (
  (map (c: get c "base" { }) configs)
  ++ (map (c: { home-manager.users."${metadata.usernameLower}" = (get c "hm" { }); }) configs)
)
