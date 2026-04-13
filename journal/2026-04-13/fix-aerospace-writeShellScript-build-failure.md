`nix build .#darwinConfigurations.beleap-m1air.system` failed during Home Manager's AeroSpace config generation.

Observed error:

```text
error: cannot coerce a function to a string: «lambda writeShellScript ...»
```

Root cause:

- [config/recipe/aerospace/default.nix](/Users/beleap/nix-configuration/config/recipe/aerospace/default.nix:9) called `pkgs.writeShellScript` with an attribute set.
- In `nixpkgs`, `writeShellScript` takes positional arguments: `name` and `text`.
- That incorrect call left `pip-handler` and `workspace-change-handler` as functions instead of store paths.
- `programs.aerospace.userSettings.exec-on-workspace-change` later interpolated one of those values into the generated `aerospace.toml`, which triggered the coercion failure.

Fix:

- Rewrote both helper scripts to use `pkgs.writeShellScript "name" ''...''`.
- Kept behavior unchanged and added shell quoting for the window id and focused workspace arguments.

Verification:

- `nix build .#darwinConfigurations.beleap-m1air.system` succeeded after the change.
