# Allow Jujutsu metadata in the Pi sandbox

Pi's `pi-landstrip` extension blocked `jj log` because Jujutsu stores colocated repository metadata under `~/.config/jj/repos`.

Added `config/recipe/pi/sandbox.json`, preserving the complete existing global sandbox policy while adding read/write access to `~/.config/jj`. Updated `config/recipe/pi/default.nix` to install that standalone file as `~/.pi/agent/sandbox.json` through Home Manager. Both permissions are required because ordinary `jj` operations may update repository metadata.

The sandbox configuration is loaded when Pi starts, so apply the Home Manager/Nix configuration and restart Pi before testing.
