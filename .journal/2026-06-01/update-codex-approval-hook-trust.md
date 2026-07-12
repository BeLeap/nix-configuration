# update codex approval hook trust

- Fixed the declarative Codex `PermissionRequest` hook trust state in `config/recipe/codex/default.nix`.
- `codex app-server` `hooks/list` reported the existing hook as `modified` under Codex `0.135.0`.
- Updated the trusted hash to the current hook hash:
  - `sha256:e97584cd8c170a6dc8dd63f53d103c4f3de3b4fe3af30a0555393396d85c8d45`
- The hook key remains `${config.home.homeDirectory}/.codex/config.toml:permission_request:0:0` so the Home Manager-managed `~/.codex/config.toml` can carry the trust state declaratively.
