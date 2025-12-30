_: {
  base =
    { inputs, ... }:
    {
      nixpkgs.overlays = [
        (import ./pkgs/overlay.nix {
          inherit (inputs) kubectl-check boda;
        })
        (import inputs.beleap-overlay)
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev) config;
            inherit (prev.stdenv.hostPlatform) system;
          };
        })
      ];
    };
}
