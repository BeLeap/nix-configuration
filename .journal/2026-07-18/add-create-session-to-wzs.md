# Add create-session option to `wzs`

Added a visible **Create new session** entry when `wzs` opens its picker. `wzs` appends that entry to `wzsf` through its standard input and interprets the selected action itself; selecting it prompts for a session name, then uses the existing workspace creation and activation path. `wzsf` has no create-session-specific behavior: it only supports generically appending piped candidates to its workspace list, while direct usage continues to list only existing workspaces.

Validation:
- `bash -n` passed for `wzs` and `wzsf`.
- `shellcheck` passed for both scripts.
- A mocked picker test confirmed that direct `wzsf` excludes the create action and that a generic piped candidate is appended and can be selected.
- A Nix build could not run because this sandbox cannot access the Nix daemon socket.
- An initial pseudo-terminal test could not run because the sandbox denied `openpty`; the prompt was then tested directly with piped input instead.
