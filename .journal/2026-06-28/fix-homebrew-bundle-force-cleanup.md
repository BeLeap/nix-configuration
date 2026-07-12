# Fix Homebrew Bundle force cleanup flag

- `brew bundle` no longer accepts `--force-cleanup`; the supported cleanup flag is `--cleanup`, with `--zap` for cask zap behavior.
- The pinned nix-darwin 26.05 Homebrew module documents `cleanup = "zap"` as `--cleanup --zap`, but currently renders it as `--zap --force-cleanup`.
- Updated `config/recipe/macos/homebrew/default.nix` to set `homebrew.onActivation.cleanup = "none"` and pass `["--cleanup" "--zap" "--verbose"]` through `extraFlags`.
- This preserves the previous zap cleanup intent while avoiding the removed Homebrew Bundle flag.
