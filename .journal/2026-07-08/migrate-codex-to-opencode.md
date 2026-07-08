## Migrated Codex Recipe To Opencode

- Moved the Context7 API key age secret from `config/recipe/codex/secrets/` to `config/recipe/opencode/secrets/`.
- Added opencode settings for `openai/gpt-5.5`, Context7 remote MCP, global instructions, and conservative ask-on-edit/bash permissions.
- Linked shared `files/AGENTS.md` to `~/.config/opencode/AGENTS.md` and configured opencode to load it.
- Removed the Codex recipe, Codex rules, Codex wrapper, and approval-focus hook.
- Removed the shared `.codex/AGENTS.md` Home Manager file link.

Validation:

- Ran `nix fmt .` successfully.
- Evaluated `.#darwinConfigurations.beleap-m1air.config.home-manager.users.beleap.programs.opencode.settings.model` successfully.
- Evaluated `.#nixosConfigurations.vm-arm64-Darwin-personal.config.home-manager.users.beleap.programs.opencode.settings.mcp.context7.type` successfully.

Note: opencode config is loaded at process startup, so restart opencode after applying Home Manager changes.
