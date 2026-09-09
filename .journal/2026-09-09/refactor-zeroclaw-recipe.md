# Refactor ZeroClaw recipe

## Outcome

- Extracted Ollama and ZeroClaw service implementations from `config/recipe/beleap-macmini/default.nix` into independently selectable `ollama` and `zeroclaw` recipes.
- Moved ZeroClaw TOML, daemon generation, Pi delegation runner, and skill assets under `config/recipe/zeroclaw/`.
- Added typed ZeroClaw options and assertions for host-specific values, private paths, and gateway binding.
- Preserved the pulled `agent-browser` integration from commit `4360134d`: skill installation, shell allowlist, and launchd `PATH`.
- Preserved Google Calendar MCP from commit `22c9f62a`: deferred HTTP MCP server, `google_calendar` bundle, default-agent assignment, and auto-approved `tool_search` discovery.
- Resolved the Jujutsu rebase conflict after the Google Calendar commit was pulled; no conflict markers remain.

## Validation

- Mac mini Darwin system evaluation passed.
- Mac mini Darwin system build passed.
- Generated ZeroClaw TOML parsed successfully and asserted the Google Calendar MCP settings.
- Alejandra, Statix, Deadnix, ShellCheck, Nix parsing, and shell syntax checks passed for the changed recipe.
- No system activation was performed.

## Limitation

- Repository-wide `nix flake check --all-systems` remains blocked by the existing unsupported `ax-cli` package while evaluating the aarch64-linux VM configuration.

## Follow-up diagnosis — ZeroClaw package split

- `config/recipe/zeroclaw/default.nix` currently runs the daemon from `inputs.llm-agents.packages.${system}.zeroclaw` but exposes `pkgs.unstable.zeroclaw` as the interactive `zeroclaw` command.
- Evaluated versions are `llm-agents` ZeroClaw 0.8.5 and `nixpkgs-unstable` ZeroClaw 0.8.3. The split originated when the daemon reference moved to `llm-agents`; the Home Manager package remained from the earlier unstable-package change.
- No package-level limitation requires two ZeroClaw derivations. Unless the version divergence is intentional, use one derivation for both the LaunchAgent and `home.packages` to avoid CLI/daemon version skew.

## Follow-up implementation

- Removed `zeroclawCliPackage`; `home.packages` now installs the same `zeroclawPackage` used by the LaunchAgent.
- Validation passed: Nix parsing, Alejandra, Statix, and the `beleap-macmini` Darwin build.
