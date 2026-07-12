Investigated what can be configured in Pi (pi.dev). The local nix-configuration repo has no pi.dev-specific module or host. Public Pi docs show configuration via ~/.pi/agent/settings.json and .pi/settings.json, plus keybindings.json, models.json, extensions, skills, prompt templates, themes, packages, AGENTS.md, SYSTEM.md, trust settings, and CLI/environment overrides.

Added initial Pi setup as a dedicated `config/recipe/pi/default.nix` recipe. The recipe installs `pkgs.llm-agents.pi` through Home Manager and links shared agent instructions to `~/.pi/agent/AGENTS.md`. Wired the recipe into `config/recipe/development/default.nix` so development hosts receive Pi alongside opencode.

Verification: `nix run nixpkgs#alejandra -- --check .`, host output evals, focused eval for `pi-0.80.5` in `beleap-m1air` Home Manager packages, focused eval for `.pi/agent/AGENTS.md`, and `nix build '.#darwinConfigurations.beleap-m1air.system' --accept-flake-config --no-link` all passed.
