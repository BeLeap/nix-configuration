# Tidy `lib/mkSystem.nix` input destructuring

- User request: "정리할만한거 있으면 찾아서 정리해봐".
- Applied a tidy-first cleanup in `lib/mkSystem.nix` by narrowing the argument destructuring to only the fields actually used (`lib`, `metadata`, `recipes`) and replacing the rest with `...`.
- Motivation: remove dead/unused parameter bindings and reduce noise while preserving behavior.

## Validation

- Attempted to run `nix run nixpkgs#deadnix -- .`, but this environment does not have `nix` installed (`nix: command not found`).
