# Add try CLI

- Added `github:tobi/try` as a flake input following the main `nixpkgs` input.
- Added `config/recipe/try/default.nix` to import the upstream Home Manager module and enable `programs.try`.
- Included the new `try` recipe in the development recipe set.
- Threaded the explicit `try` input through `lib/mkSystem.nix` so the recipe loader can pass it to recipes.
- Updated `flake.lock` and verified with `nix flake check`.
- `nix flake check` passed with existing Home Manager default-change warnings for `xdg.userDirs.setSessionVariables`, `programs.zsh.dotDir`, and `programs.firefox.configPath`.
