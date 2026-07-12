# Change Default Shell To Zsh

- Moved the login shell assignment from the `fish` recipe to the `zsh` recipe.
- Enabled system-level zsh support and set `${metadata.usernameLower}` to use `pkgs.zsh`.
- Added `pkgs.zsh` to `environment.shells` so it is registered as an available shell.
- Removed fish from the development recipe, available shells, and tmux startup command.
- Deleted the unused fish recipe.
