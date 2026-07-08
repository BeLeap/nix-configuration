## Ghostty terminal migration

- Replaced the development recipe's `alacritty` dependency with `ghostty`.
- Added `config/recipe/ghostty/default.nix` using Home Manager `programs.ghostty` with `pkgs.ghostty-bin` because source `pkgs.ghostty` is Linux-only in the pinned nixpkgs.
- Preserved the prior terminal behavior by launching zsh into `tmux new-session -As sp`.
- Updated the macOS Dock entry to `Ghostty.app` from `ghostty-bin` and removed the old Alacritty Aerospace rule; the Ghostty rule already existed.
- Verified `nix fmt .` and Darwin evaluations for `beleap-m1air`, `beleap-macmini`, and `csjang-m3pro`.
