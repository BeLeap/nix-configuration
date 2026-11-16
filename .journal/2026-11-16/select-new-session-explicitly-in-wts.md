# Select `New Session` explicitly in `wts`

## Outcome

- Added a `New Session` entry to the `wts` picker.
- Selecting `New Session` prompts for a name, then creates the date-prefixed workspace directory.
- An unmatched query no longer creates a workspace.
- `wts` reports workspace-listing errors instead of treating them as an empty selection.

## Validation

- `bash -n config/recipe/overlay/pkgs/beleap-utils/scripts/wts` passed.
- ShellCheck passed for `config/recipe/overlay/pkgs/beleap-utils/scripts/wts`.
- Mocked checks passed for existing workspaces, explicit creation, empty names, unmatched queries, cancellation, invalid names, and command errors.
