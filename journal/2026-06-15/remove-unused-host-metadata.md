# Remove unused host metadata

- Removed `kind` and `gui` from `config/hosts.nix`.
- Those concepts are now expressed by explicit recipes such as `macos/personal`, `macos/work`, and `nixos/gui`.
- Kept `os`, `arch`, and `distribution` because they still drive platform derivation and flake output selection.
