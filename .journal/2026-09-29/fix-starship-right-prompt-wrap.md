# Fix Starship right-prompt wrap

- Reapplied the Starship layout change after it was rolled back: moved `$os` and `$shell` into the left `format` before `$character`. They remain visible; Starship's `$all` omits modules already listed in `format`, shortening the crowded right prompt.
- Validation passed: `nix-instantiate --parse`, Alejandra `--check`, and Starship config parse/render using a unique scratch config. Right-prompt output shrank from 318 to 274 characters in the live environment.
- The first scratch test could not overwrite a prior scratch file (`Permission denied`); rerunning with a unique temporary file passed.
- No Home Manager or nix-darwin activation was run. The working copy also contains an unrelated pending `config/recipe/omniwm/settings.toml` edit; a full switch would apply it too.
