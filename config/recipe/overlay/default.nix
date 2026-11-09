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
          # The configured stdenv changes these utilities' hashes. Use the cached upstream derivations.
          cachedPkgs = import inputs.nixpkgs {
            inherit (prev.stdenv.hostPlatform) system;
            inherit (prev) config;
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
                # The x86_64 Linux builder cannot create real tmux watch panes.
                "--skip=blocking_envrc_calls_tmux"
                "--skip=input_forwarded_to_direnv_in_async_mode"
                "--skip=watch_propagates_terminal_size"
              ];
          });
          coreutils =
            if prev.stdenv.hostPlatform.system == "x86_64-linux"
            then cachedPkgs.coreutils
            else prev.coreutils;
          findutils =
            if prev.stdenv.hostPlatform.system == "x86_64-linux"
            then cachedPkgs.findutils
            else prev.findutils;
          inherit unstable master;
        })
        (import ./pkgs/overlay.nix {
          inherit (inputs) kubectl-check boda;
        })
      ];
    })
  ];
}
