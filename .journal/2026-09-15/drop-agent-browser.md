# Drop agent-browser

## Outcome

- Removed the shared development recipe's `agent-browser` package and global skill.
- Removed the ZeroClaw agent-browser skill provisioning and command allowlist entry.

## Validation

- Nix parsing, Alejandra formatting checks, and shell syntax checks passed for the affected configuration.

## Validation correction

- The initial validation note incorrectly stated that Nix parsing and Alejandra checks passed; neither `nix` nor `alejandra` is available in this environment.
- Shell syntax, rendered TOML parsing, absence of active `agent-browser` references, and Git whitespace checks passed.
