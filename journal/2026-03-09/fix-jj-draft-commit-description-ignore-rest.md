# Fix jj draft commit description ignore-rest

## Summary
- Updated `config/recipe/jujutsu/default.nix` `templates.draft_commit_description`.
- Added `"JJ: ignore-rest\n"` before `diff.git()` so git-style diff preview is not included in the saved commit message.

## Why
- Lines not prefixed with `JJ:` in the editor can become part of the actual commit description.
- `diff.git()` output does not start with `JJ:`, so without an ignore marker it can leak into commit messages.

## Changed files
- `config/recipe/jujutsu/default.nix`

## Follow-up
- Moved `"JJ: ignore-rest\n"` above the `"JJ: Changes in this commit:"` line so the header is also excluded from the final saved description.
- Wrapped `diff.git()` preview with fenced code block markers (` ```diff ` ... ` ``` `) to enable diff highlighting in markdown-aware editors.
