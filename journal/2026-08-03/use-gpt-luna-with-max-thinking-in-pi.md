# Use GPT Luna with max thinking in Pi

Changed Pi's declarative settings to start new sessions with `gpt-5.6-luna`
and the `max` thinking level. Luna was already included in the enabled model
list, so no model availability change was necessary.

Verification: `git diff --check` passes. The environment does not provide the
`nix` executable, so the repository's flake check could not be run locally.
