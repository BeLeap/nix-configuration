# Add `wts`

- Added the `wts NAME` utility for direct named WezTerm workspace/session access.
- `wts` creates a missing workspace with `wezterm cli spawn --new-window --workspace` and focuses an existing or newly created workspace through the configured `DO_FOCUS_WEZTERM_WORKSPACE` user variable.
- Refactored `wzs` to delegate the create-or-focus behavior to `wts`, keeping workspace selection separate from session activation.

Validation:
- `bash -n` passed for `wts` and `wzs`.
- Mocked WezTerm checks passed for existing-workspace attach behavior, missing-workspace creation, missing-name usage errors, and `wzs` delegation.
- `shellcheck` was not available in the environment.

## Correction (2026-08-14)

- The initial implementation incorrectly made `wzs` delegate to `wts`; `wzs` remains unchanged as the existing workspace switcher.
- `wts` now separately runs `try exec --path "$HOME/ws" . NAME` when the named WezTerm workspace is missing, starts the new session in the resulting directory, and focuses existing sessions without invoking `try`.

## Follow-up correction (2026-08-14)

- `wts` now invokes `try exec --path "$HOME/ws" NAME` first, allowing the try selector to choose an existing directory or create a new one.
- The selected directory becomes the new WezTerm workspace's working directory; the supplied `NAME` remains the WezTerm workspace name used for attach/focus.

## Validation correction (2026-08-14)

- Revalidated Bash syntax and mocked the try-first flow: try selection runs before WezTerm inspection, existing named sessions are focused without spawning, and missing sessions spawn with the selected directory as `--cwd`.
- Confirmed `wzs` remains independent of `try` and its existing behavior is preserved.
- Added the configured `try` package to `home.packages` because its Home Manager module otherwise exposes `try` only through a shell function; the standalone `wts` script needs the executable on `PATH`.

## Interactive selection correction (2026-08-14)

- `wts` now accepts an optional name. With no name, it invokes `try` without a search term so the full interactive selector is shown; with a name, the name remains the selector's initial query.
- When no name is supplied, the selected try directory basename is used as the WezTerm workspace name.

## Optional-name validation (2026-08-14)

- Mocked validation passed for no-name interactive selection, named selection, existing-session focus, missing-session spawn, preserved `wzs` behavior, and argument validation.

## Workspace naming correction (2026-08-14)

- `wts` now always derives the WezTerm workspace name from the selected try directory basename, regardless of whether an initial name was supplied.
