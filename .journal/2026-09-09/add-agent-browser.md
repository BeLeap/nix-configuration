# Add agent-browser

## Outcome

- Added a dedicated `agent-browser` recipe and included it in the shared development recipe.
- Installed the Nix-packaged `agent-browser` 0.37.0 from `llm-agents.nix`.
- Exposed the package's version-matched discovery skill through `~/.agents/skills/agent-browser`, which Pi discovers globally.
- Updated the `beleap-macmini` ZeroClaw daemon to copy the same `SKILL.md` into `~/.zeroclaw/agents/default/workspace/skills/agent-browser/`, allow the `agent-browser` shell command, and provide the Home Manager profile on the daemon `PATH`.
- Browser binaries are not downloaded during Nix activation. Run `agent-browser install` once after activating the configuration.

## Validation

- Alejandra, Statix, Deadnix, and shell syntax checks passed.
- ZeroClaw skill audit passed for the packaged agent-browser skill.
- Darwin builds passed for `beleap-macmini` and `beleap-m1air`.
- `nix flake check --no-build` remains blocked by the existing unsupported `ax-cli` package while evaluating the aarch64-linux VM configuration.
