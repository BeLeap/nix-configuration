# Configure jj draft template with scissors and diff body

## Goal
- Keep `JJ:` comment semantics and show full `diff.git()` body in draft description.
- Stay compatible with Helix `jjdescription` highlighting pipeline.

## Change
- Updated `config/recipe/jujutsu/default.nix`:
  - `templates.draft_commit_description` now renders:
    - `description`
    - `JJ: ignore-rest`
    - `JJ: ------------------------ >8 ------------------------`
    - `diff.git()`

## Important
- This change requires Home Manager apply (`home-manager switch`) before `jj describe` uses it.
- Captured draft content before apply still showed builtin-style file list only.
