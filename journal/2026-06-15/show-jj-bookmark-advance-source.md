# Show jj bookmark advance source in Starship

- Updated `custom.jj_bookmark` in `config/recipe/starship/default.nix`.
- It now reads bookmarks from `heads(::@ & bookmarks())`, matching the default source revset used by `jj bookmark advance`.
- This makes the prompt show the nearest bookmark that `jj ba` would advance to the current working-copy change, even when the bookmark is still on an ancestor rather than on `@`.
