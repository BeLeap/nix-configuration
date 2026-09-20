# Drop mac-app-util after activation failure

- Reproduced the Darwin activation error by running the generated `mac-app-util` binary directly; it failed with `failed to allocate 1048576 bytes at 0x300100000`.
- Removed the `macAppUtil` recipe from `config/recipe/macos/default.nix`, deleted its recipe, removed the `mac-app-util` flake input, and pruned its lock-file dependencies.
- Focused Darwin evaluation and Alejandra formatting passed. `nh darwin switch` built the new system successfully and showed `mac-app-util` plus SBCL removed from the closure.
- Activation could not complete from the agent shell because `sudo` requires an interactive password. Apply from a terminal with `sudo -v && nh darwin switch`.
- During diagnosis, `brew bundle check` auto-updated Homebrew from 6.0.20 to 7.0.4; no Homebrew packages were intentionally removed.
