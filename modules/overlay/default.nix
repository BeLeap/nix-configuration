{
  kubectl-check,
  boda,
  beleap-overlay,
  nixpkgs-unstable,
}:
[
  {
    nixpkgs.overlays = [
      (import ./pkgs/overlay.nix {
        inherit kubectl-check boda;
      })
      (import beleap-overlay)
      (final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (prev) config;
          inherit (prev.stdenv.hostPlatform) system;
        };
      })
    ];
  }
]
