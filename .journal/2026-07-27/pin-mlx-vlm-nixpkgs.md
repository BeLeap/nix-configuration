# Use stable nixpkgs for mlx-vlm

GitHub Actions run 30226203684 failed only while building `beleap-macmini` after
the automated lock update moved `nixpkgs-unstable` from
`7525d999cd850b9a488817abc89c75dc733acf17` to
`37bfb33419c6e367e8bb6f44041eaecf953b5236`. The other two Darwin hosts built
successfully; `beleap-macmini` is the only host that includes `mlx-vlm`.

`mlx-vlm` is available at the same version in the stable nixpkgs package set, so
the Mac mini now uses `pkgs.python313Packages.mlx-vlm`. This isolates the package
from broad `nixpkgs-unstable` lock updates without adding another pinned input or
overlay attribute.

Validation:

- Nix evaluation resolved the stable package as `python3.13-mlx-vlm-0.4.4`.
- Nix evaluation was attempted locally, but evaluating the full Darwin system
  exceeded the Linux container's available memory. CI on an Apple runner remains
  the authoritative full build check.
