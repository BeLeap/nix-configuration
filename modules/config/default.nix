{
  metadata,
  lib,
  ...
}:
let
  get =
    a: k: e:
    if (builtins.elem k (builtins.attrNames a)) then a."${k}" else e;
  configs = map (p: (import (./. + "/configs/${p}"))) [
    "common"
    "kubernetes"
  ];
  filtered = lib.flatten (
    [ ]
    ++ (map (c: get c "common" [ ]) configs)
    ++ lib.optionals (metadata.distribution == "nixos") (map (c: get c "nixos" [ ]) configs)
    ++ lib.optionals (metadata.distribution == "macos") (map (c: get c "macos" [ ]) configs)
  );
in
lib.flatten (
  (map (c: get c "config" { }) filtered)
  ++ (map (c: { home-manager.users."${metadata.usernameLower}" = (get c "hm" { }); }) filtered)
)
