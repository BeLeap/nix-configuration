# Harden recipe loader

## Outcome

- Added pure `lib/recipe-graph.nix` traversal with strict declaration validation, stable preorder traversal, first-occurrence deduplication, missing-recipe failures, and complete cycle paths.
- Migrated every recipe declaration from `recipes`/`base`/`hm` to `includes`/`systemModules`/`homeModules`.
- Replaced the loader's per-recipe Home Manager wrappers with one user-specific wrapper importing the aggregated Home Manager module list.
- Added focused graph tests and wired them into flake checks.
- Documented the declaration schema and compatibility ordering in `README.md` and the loader.

## Expansion comparison

The before and after expansion lists were identical, including order. The following lists are the common before/after result for each host:

- `beleap-m1air`: `default -> overlay -> hm -> base -> nix -> agenix -> development -> wezterm -> zsh -> lsd -> starship -> helix -> zoxide -> direnv -> git -> fzf -> gh -> bash -> jujutsu -> ssh -> podman -> nodejs -> pi -> try -> firefox -> kubernetes -> macos -> hm/macos -> macAppUtil -> nix/macos -> nh/macos -> podman/macos -> ws-cleanup/macos -> aerospace -> macos/homebrew -> macos/personal -> discord -> beleap-m1air -> personal -> joplin -> syncthing -> keepassxc -> onedrive -> 1password -> 1password/macos -> kdeconnect-mac`
- `beleap-macmini`: `default -> overlay -> hm -> base -> nix -> agenix -> development -> wezterm -> zsh -> lsd -> starship -> helix -> zoxide -> direnv -> git -> fzf -> gh -> bash -> jujutsu -> ssh -> podman -> nodejs -> pi -> try -> firefox -> kubernetes -> macos -> hm/macos -> macAppUtil -> nix/macos -> nh/macos -> podman/macos -> ws-cleanup/macos -> aerospace -> macos/homebrew -> macos/personal -> discord -> beleap-macmini -> personal -> joplin -> syncthing -> keepassxc -> onedrive -> 1password -> 1password/macos -> kdeconnect-mac`
- `csjang-m3pro`: `default -> overlay -> hm -> base -> nix -> agenix -> development -> wezterm -> zsh -> lsd -> starship -> helix -> zoxide -> direnv -> git -> fzf -> gh -> bash -> jujutsu -> ssh -> podman -> nodejs -> pi -> try -> firefox -> kubernetes -> macos -> hm/macos -> macAppUtil -> nix/macos -> nh/macos -> podman/macos -> ws-cleanup/macos -> aerospace -> macos/homebrew -> macos/work -> work`
- `vm-arm64-Darwin-personal`: `default -> overlay -> hm -> base -> nix -> agenix -> development -> wezterm -> zsh -> lsd -> starship -> helix -> zoxide -> direnv -> git -> fzf -> gh -> bash -> jujutsu -> ssh -> podman -> nodejs -> pi -> try -> firefox -> kubernetes -> nixos -> hm/nixos -> nix/nixos -> nh/nixos -> ws-cleanup/nixos -> vm -> nixos/vm -> personal -> joplin -> syncthing -> keepassxc -> 1password -> 1password/nixos`
- `vm-arm64-Darwin-work`: `default -> overlay -> hm -> base -> nix -> agenix -> development -> wezterm -> zsh -> lsd -> starship -> helix -> zoxide -> direnv -> git -> fzf -> gh -> bash -> jujutsu -> ssh -> podman -> nodejs -> pi -> try -> firefox -> kubernetes -> nixos -> hm/nixos -> nix/nixos -> nh/nixos -> ws-cleanup/nixos -> vm -> nixos/vm -> work`

## Validation

- `nix-instantiate --parse` passed for all Nix files under `config`, `lib`, and `tests`.
- Focused graph tests passed for ordering, root ordering, diamond deduplication, unknown roots/includes, unknown fields, non-list fields, non-string includes, nested module lists, and cycles.
- Direct error checks reported `a -> b -> c -> a` and an actionable unknown-root message.
- `alejandra --check ...` passed.
- `nix run nixpkgs#statix -- check .` passed.
- `nix run nixpkgs#deadnix -- .` exited successfully; it continues to report pre-existing unused arguments in the Home Manager, overlay, and system assembly files.
- `nix flake check --no-build --all-systems --show-trace` passed, with existing Home Manager default-change warnings.
- All five host system derivation paths evaluated successfully. No system build or switch was performed.

## Generated option inspection

- Evaluated generated `environment.systemPackages` and service option names for all five hosts after migration.
- Darwin and NixOS option evaluation completed without new failures; the expected Home Manager service names remained user-specific on NixOS.

## Naming follow-up

- Renamed `config/recipe-loader.nix` to `config/recipe-assembly.nix` to distinguish filesystem/dependency injection and Home Manager wiring from pure graph traversal.
- Updated `lib/mkSystem.nix`, `README.md`, and the active enhancement document. Historical journal entries retain their original wording.

## Function-only follow-up

- Restricted recipe graph resolvers to resolver functions; registry attribute-set resolvers now fail explicitly.
- Restricted `systemModules` and `homeModules` to function-valued modules.
- Wrapped existing path and attribute-set modules in function modules, using nested `imports` for path modules so Nix supplies module arguments normally.
- Updated focused tests and contract documentation.

Validation after this follow-up:

- All selectable recipe module values type-check as functions.
- `nix flake check --no-build --all-systems --show-trace` passed.
- Focused graph tests, Alejandra, Statix, Deadnix, and Nix parsing passed.
- Verified all 66 recipe entrypoints evaluate to functions; `config/recipe-assembly.nix` now rejects any non-function entrypoint with its path and actual type.
- Re-ran parsing, focused graph tests, Alejandra, Statix, and cross-system flake evaluation successfully.

Correction: the recursive entrypoint inventory contains 63 `default.nix` files, not 66; all 63 evaluate to functions.
