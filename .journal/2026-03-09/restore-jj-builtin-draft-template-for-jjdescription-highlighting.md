# Restore jj builtin draft template for jjdescription highlighting

## Why
- `jjdescription` in Helix has a dedicated grammar/query set.
- Diff highlighting is designed around jj's built-in draft description structure.
- Custom fenced markdown diff (` ```diff `) can bypass that flow and lose highlighting.

## Changes
- Updated `config/recipe/jujutsu/default.nix`:
  - `templates.draft_commit_description = "builtin_draft_commit_description";`

## Outcome
- Keeps jj comment/ignore semantics.
- Restores compatibility with Helix `jjdescription` highlighting behavior.

## Validation
- `nix-instantiate --parse config/recipe/jujutsu/default.nix` OK
