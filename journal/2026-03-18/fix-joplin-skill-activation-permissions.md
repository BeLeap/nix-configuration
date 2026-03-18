# Fix Joplin Skill Activation Permissions

## Summary

- Confirmed `home.activation.copyFiles` copied the vendored `joplin-cli` skill from the Nix store with read-only directory modes.
- Confirmed subsequent activations failed on `rm -rf ~/.agents/skills/joplin-cli` because the copied directories were not user-writable.
- Extracted the writable-delete-copy activation logic into a shared helper under `lib/hm/install-store-dir.nix`.
- Updated the Joplin recipe to use that shared helper for installing `~/.agents/skills/joplin-cli`.

## Verification

- Inspected the installed skill tree permissions under `~/.agents/skills/joplin-cli` and observed read-only directory and file modes.
- Checked Home Manager activation hook guidance and recursive file installation patterns via Context7 before updating the activation logic.
