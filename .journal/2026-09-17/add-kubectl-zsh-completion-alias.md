# Add kubectl zsh completion for `k`

- Added optional `kubectl completion zsh` initialization to `config/recipe/zsh/default.nix`.
- Registered the generated `_kubectl` completion function for the existing `k` alias, which continues to invoke `kubectl-check`.

## Validation

- `alejandra --check config/recipe/zsh/default.nix`: passed.
- Isolated zsh smoke test confirmed `_comps[k] = _kubectl`: passed.
- Darwin host build for `beleap-m1air`: passed.
- `nix flake check --no-build --show-trace`: blocked by the existing unsupported `ax-cli` package on `aarch64-linux`.

## Follow-up correction

- The initial `compdef k=kubectl` mapping did not work because this configuration expands `k` to `kubectl-check`, not directly to `kubectl`.
- Registered `_kubectl` for `kubectl-check`; an interactive zsh smoke test then returned Kubernetes resources for `k get <TAB>`.
