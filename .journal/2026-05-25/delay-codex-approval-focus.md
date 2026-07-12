# delay codex approval focus

- Updated `config/recipe/codex/default.nix` so the Codex approval focus hook warns before stealing focus.
- The hook now sends a macOS notification:
  - `Approval requested. Focusing Codex in 5 seconds.`
- Added a 5 second delay before tmux pane/window selection and terminal app activation.
- Increased the Codex hook timeout from 5 seconds to 10 seconds so the intentional delay is not killed by the hook runner.
- Updated the hook trust hash to:
  - `sha256:b221147b013ade09adf1b98730c14270f8649adc1a14c7e0effb3ddf40dad094`
- Verification:
  - `nix run nixpkgs#alejandra -- config/recipe/codex/default.nix`
  - `nix eval .#darwinConfigurations.beleap-m1air.config.system.build.toplevel.drvPath --raw`
  - Used `codex app-server` `hooks/list` with a temporary `CODEX_HOME` to retrieve the updated hook hash.
