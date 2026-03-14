# Fix Codex Joplin Skill Install Path

## Summary

- Confirmed the vendored `joplin-cli` skill was being installed only to `~/.agents/skills/joplin-cli`.
- Confirmed the active Codex runtime in this environment discovers built-in and user skills from `~/.codex/skills`, not `~/.agents/skills`.
- Updated the Joplin Home Manager recipe to install the skill into `~/.codex/skills/joplin-cli`.
- Kept the legacy `~/.agents/skills/joplin-cli` install path for compatibility with older tooling or earlier documentation.

## Verification

- Compared the active runtime skill directory contents under `~/.codex/skills` and `~/.agents/skills`.
- Compared the vendored skill structure against the built-in skill layout under `~/.codex/skills/.system`.
- Checked Home Manager `home.file` recursive directory linking docs via Context7 before updating the install target.
