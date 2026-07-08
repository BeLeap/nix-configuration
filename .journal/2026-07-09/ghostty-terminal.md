## Ghostty terminal migration

- Replaced the development recipe's `alacritty` dependency with `ghostty`.
- Added `config/recipe/ghostty/default.nix` using Home Manager `programs.ghostty` with platform-aware package selection: `pkgs.ghostty-bin` on Darwin and `pkgs.ghostty` elsewhere.
- Preserved the prior terminal behavior by launching zsh into `tmux new-session -As sp`.
- Updated the macOS Dock entry to `Ghostty.app` from `ghostty-bin` and removed the old Alacritty Aerospace rule; the Ghostty rule already existed.
- Verified `nix fmt .`, Darwin evaluation for `beleap-m1air`, and NixOS evaluations for `vm-arm64-Darwin-personal` and `vm-arm64-Darwin-work` after making package selection platform-aware.
