# Fix Joplin Skill Activation Permissions

## Summary

- Confirmed `home.activation.copyFiles` copied the vendored `joplin-cli` skill from the Nix store with read-only directory modes.
- Confirmed subsequent activations failed on `rm -rf ~/.agents/skills/joplin-cli` because the copied directories were not user-writable.
- Extracted the writable-delete-copy shell body into a shared helper under `lib/hm/install-store-dir-script.nix`.
- Kept `lib.hm.dag.entryAfter ["writeBoundary"]` in the Joplin recipe so the recipe still owns activation ordering while reusing the script body.
- Hoisted the helper import to the recipe top level once it no longer depended on the Home Manager module-scoped `lib`.

## Verification

- Inspected the installed skill tree permissions under `~/.agents/skills/joplin-cli` and observed read-only directory and file modes.
- Checked Home Manager activation hook guidance and recursive file installation patterns via Context7 before updating the activation logic.
