# Set up pi-landstrip

- Added `npm:pi-landstrip@0.16.29` to the declarative Pi package list in `config/recipe/pi/default.nix`.
- pi-landstrip's default policy provides workspace-scoped reads/writes, disabled-by-default network access, OS-level sandboxing, and interactive approval prompts.
- `nh darwin switch` built successfully but could not activate because this non-interactive session could not provide the required sudo password. Run it from an interactive terminal, then restart Pi.
