_: {
  system = [
    ({inputs, ...}: {
      nixpkgs.overlays = [
        inputs.nur.overlays.default
        inputs.beleap-overlay.overlays.default
        inputs.jj-starship.overlays.default
        (_final: prev: let
          withoutBundledModules = discord:
            discord.override {
              # Nixpkgs adds these files under the signed app bundle, which
              # invalidates Discord's upstream notarized resource seal.
              # see: https://github.com/NixOS/nixpkgs/issues/544338
              source =
                discord.source
                // {
                  modules = {};
                };
            };
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev) config;
            inherit (prev.stdenv.hostPlatform) system;
          };
        in {
          python313 = prev.python313.override {
            packageOverrides = _: pyp: {
              accelerate = pyp.accelerate.overridePythonAttrs (_: {doCheck = false;});
              peft = pyp.peft.overridePythonAttrs (_: {doCheck = false;});
            };
          };
          discord = withoutBundledModules prev.discord;
          unstable =
            unstable
            // {
              discord = withoutBundledModules unstable.discord;
            };
        })
        (import ./pkgs/overlay.nix {
          inherit (inputs) kubectl-check boda;
        })
      ];
    })
  ];
}
