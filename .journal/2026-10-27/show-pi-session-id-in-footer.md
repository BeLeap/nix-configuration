# Show Pi's session ID in the footer

Added an autoloaded Pi extension that displays the full current session ID as
`sid:<id>` in the footer. It refreshes on each `session_start` event and clears
its status entry on shutdown.

Validation:

- Alejandra formatting check passed for `config/recipe/pi/default.nix`.
- Pi loaded the extension successfully with `pi -ne -e ... --list-models`.
- The focused `beleap-m1air` Home Manager evaluation resolved the extension source
  to the Nix store. The new file was temporarily added to Git's index for this
  evaluation because Nix flakes omit untracked files, then unstaged.

The Pi load check also synchronized Pi's configured package store under
`~/.pi/agent`.
