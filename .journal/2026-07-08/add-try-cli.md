# Add try CLI

- Added `github:tobi/try` as a flake input following the main `nixpkgs` input.
- Added `config/recipe/try/default.nix` to import the upstream Home Manager module and enable `programs.try`.
- Included the new `try` recipe in the development recipe set.
- Threaded the explicit `try` input through `lib/mkSystem.nix` so the recipe loader can pass it to recipes.
- Updated `flake.lock` and verified with `nix flake check`.
- `nix flake check` passed with existing Home Manager default-change warnings for `xdg.userDirs.setSessionVariables`, `programs.zsh.dotDir`, and `programs.firefox.configPath`.

## Follow-up fix (2026-08-08)

- Investigated the reported runtime failure: the generated zsh `try` function called `/usr/bin/env ruby`, which selected macOS's Ruby 2.6.10. `try` 1.9.0 uses `Data.define`, so interactive execution failed before the selector opened.
- The package wrapper already used Ruby 3.3, but the generated shell function bypassed that wrapper's PATH. Added `pkgs.ruby_3_3` to the Home Manager packages and explicitly used the same Ruby for the try package override.
- Validation: Alejandra, targeted Darwin/Home Manager evaluation, fixed package build, and a TTY zsh smoke test with `noclobber` passed. The smoke test printed `try v1.9.0` help without the Ruby error.
- The fix still requires `nh darwin switch` and a new zsh session (or `source ~/.zshrc`) on the machine before the active shell uses the new package/runtime.
