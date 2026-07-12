## Joplin sync failure: broken settings symlink

- Symptom: `cat ~/.config/joplin/settings.json` returned `No such file or directory`, and `joplin sync` failed.
- Root cause: `home.file.".config/joplin/settings.json"` used `mkOutOfStoreSymlink` to `config.age.secrets."joplin-settings".path`.
- On Darwin, agenix home path defaults to `$(getconf DARWIN_USER_TEMP_DIR)/agenix/<name>`. Through `mkOutOfStoreSymlink`, this became a literal unresolved symlink chain in `/nix/store`, so the final target did not exist.

## Change made

- Updated `config/recipe/joplin/default.nix`:
  - Set `age.secrets.joplin-settings.path = "${config.home.homeDirectory}/.config/joplin/settings.json";`
  - Removed `home.file` symlink block for the same file.

This makes agenix decrypt directly to Joplin's expected settings path instead of creating a broken indirection.
