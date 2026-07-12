Investigated what can be configured in Pi (pi.dev). The local nix-configuration repo has no pi.dev-specific module or host. Public Pi docs show configuration via ~/.pi/agent/settings.json and .pi/settings.json, plus keybindings.json, models.json, extensions, skills, prompt templates, themes, packages, AGENTS.md, SYSTEM.md, trust settings, and CLI/environment overrides.

Added initial Pi setup as a dedicated `config/recipe/pi/default.nix` recipe. The recipe installs `pkgs.llm-agents.pi` through Home Manager and links shared agent instructions to `~/.pi/agent/AGENTS.md`. Wired the recipe into `config/recipe/development/default.nix` so development hosts receive Pi alongside opencode.

Verification: `nix run nixpkgs#alejandra -- --check .`, host output evals, focused eval for `pi-0.80.5` in `beleap-m1air` Home Manager packages, focused eval for `.pi/agent/AGENTS.md`, and `nix build '.#darwinConfigurations.beleap-m1air.system' --accept-flake-config --no-link` all passed.

Configured Context7 for Pi using the official Pi package `npm:@upstash/context7-pi@0.1.1` in `~/.pi/agent/settings.json`. Wrapped the installed `pi` package generically as `pi` to export `CONTEXT7_API_KEY` from the existing agenix `context7-api-key` secret at runtime. The official package provides Context7 tools, the `context7-docs` skill, and `/c7-docs` prompt command.

Verification: Alejandra check passed, focused eval shows `~/.pi/agent/settings.json` contains the pinned Context7 package, focused eval shows the installed wrapper package name is `pi`, and `nix build '.#darwinConfigurations.beleap-m1air.system' --accept-flake-config --no-link` passed.

Configured Pi model defaults: `defaultProvider = "openai-codex"`, `defaultModel = "gpt-5.6-sol"`, and `enabledModels` contains OpenAI Codex models plus `openrouter/z-ai/glm-5.2` as the OpenRouter fallback/cycle option for when OpenAI Codex is rate limited. Pi settings support model cycling via Ctrl+P; no built-in automatic rate-limit fallback setting was found in the docs. Verified generated settings and rebuilt `beleap-m1air` successfully.

