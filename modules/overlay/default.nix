{
  nixpkgs-unstable,
  beleap-overlay,
  kubectl-check,
  boda,
}:
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
