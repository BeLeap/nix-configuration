_: {
  base = {inputs, ...}: {
    nixpkgs.overlays = [
      (import ./pkgs/overlay.nix {
        inherit (inputs) kubectl-check boda;
      })
      inputs.nur.overlays.default
      inputs.beleap-overlay.overlays.default
      inputs.jj-starship.overlays.default
      (_final: prev: {
        python313 = prev.python313.override {
          packageOverrides = pyf: pyp: {
            accelerate = pyp.accelerate.overridePythonAttrs (_: {doCheck = false;});
            peft = pyp.peft.overridePythonAttrs (_: {doCheck = false;});
          };
        };
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) config;
          inherit (prev.stdenv.hostPlatform) system;
        };
      })
    ];
  };
}
