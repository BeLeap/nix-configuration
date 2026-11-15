# Add `wts` to `beleap-utils`

## Outcome

- Added `config/recipe/overlay/pkgs/beleap-utils/scripts/wts`.
- `wts` lists direct subdirectories of `~/ws/` in fzf.
- Arguments prefill the fzf query.
- An unmatched query creates `YYYY-MM-DD-<name>`. The script replaces spaces in `<name>` with hyphens.
- Outside Zellij, the script uses `zellij attach --create` from the selected workspace directory.
- Inside Zellij, the script switches to an existing session or creates a background session and switches to it.
- The background session needs `$SHELL` as its initial command to remain active.
- Added `fzf`, `gnused`, and `unstable.zellij` to the `beleap-utils` runtime path.

## Validation

- `bash -n config/recipe/overlay/pkgs/beleap-utils/scripts/wts` passed.
- `shellcheck -s bash config/recipe/overlay/pkgs/beleap-utils/scripts/wts` passed through `nix shell`.
- Mocked tests passed for existing workspaces, new workspace creation, session switching, and fzf cancellation.
- `nix build .#darwinConfigurations.beleap-m1air.pkgs.beleap-utils --no-link` passed.
- `make check` failed while evaluating `nixosConfigurations.vm-arm64-Darwin-personal`. Nix rejected Darwin-only `utm-5.0.8` for `aarch64-linux`.
- Jujutsu reported unrelated changes under `config/recipe/zellij/` and in `flake.nix` and `flake.lock`. I left those changes untouched.

## Runtime probe follow-up

- A background session with `$SHELL` stayed active and the cleanup command deleted it.
- A separate `/bin/sh -c` probe wrote the expected working directory. Its cleanup command reported that the session no longer existed. `wts` uses `$SHELL`, not that custom command.

## fzf runtime validation

- Pseudo-terminal tests passed for a matched selection, a typed unmatched query, and an unmatched `--query` value.
- `fzf --print-query --bind enter:accept-or-print-query` returned the selected workspace for a match. It returned the query for no match.
