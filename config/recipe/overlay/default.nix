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
          master = import inputs.nixpkgs-master {
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
          direnv-instant = (prev.callPackage "${inputs.direnv-instant}/default.nix" {}).overrideAttrs (old: {
            checkFlags =
              (old.checkFlags or [])
              ++ prev.lib.optionals (prev.stdenv.hostPlatform.system == "x86_64-linux") [
                # The x86_64 Linux builder fails to create the real tmux watch pane.
                "--skip=blocking_envrc_calls_tmux"
              ];
          });
          inherit unstable master;
        })
        (import ./pkgs/overlay.nix {
          inherit (inputs) kubectl-check boda;
        })
      ];
    })
  ];
}
