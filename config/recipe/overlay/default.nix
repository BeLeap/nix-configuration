_: {
  base = {inputs, ...}: {
    nixpkgs.overlays = [
      (import ./pkgs/overlay.nix {
        inherit (inputs) kubectl-check boda;
      })
      inputs.nur.overlays.default
      inputs.llm-agents.overlays.default
      inputs.beleap-overlay.overlays.default
      (_final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) config;
          inherit (prev.stdenv.hostPlatform) system;
        };
      })
    ];
  };
}
