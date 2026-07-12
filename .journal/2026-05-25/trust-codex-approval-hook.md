# trust codex approval hook

- Added Codex hook trust state to `config/recipe/codex/default.nix`.
- The trusted hash is for the Nix-managed `focus-codex-approval` `PermissionRequest` hook:
  - `sha256:95abd7dbcaec8f7430f749de9e20d9cd9c45fbba75eb268c53d037a3444d5b24`
- Retrieved the hash from `codex app-server` `hooks/list` using a temporary writable `CODEX_HOME` under `/private/tmp`.
- This avoids Codex TUI trying to persist hook trust into the Home Manager managed `~/.codex/config.toml` symlink in `/nix/store`.
- Correction: Codex reads trust from top-level `hooks.state."<hook key>".trusted_hash`, not from the individual hook handler's `state`.
- The hook key includes `config.home.homeDirectory` so the config works across machines/users that share this recipe.
