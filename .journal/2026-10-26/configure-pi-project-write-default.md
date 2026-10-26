# Configure Pi's project-scoped default permissions

## Outcome

- Kept Pi's startup permission mode at `yolo`; the existing wrapper forwards the configured mode to new and child Pi sessions.
- Allowed built-in reads across project and external paths, while denying common credentials and secret files such as `.env`, `.envrc`, SSH/AWS/GPG material, package registry credentials, cloud credentials, and private-key files.
- Restricted the sandbox's configured writable root to the current project directory, including in `yolo` mode, while leaving network access unfiltered. Pi still makes its per-session scratch and runtime-managed temporary paths writable.
- Added a Pi `tool_call` guard so built-in `write` and `edit` tools cannot write outside the current project. The guard resolves symlinks and fails closed on unresolvable paths in every mode.
- Bash commands run sandboxed by default; approving an out-of-project escape runs that command unsandboxed.

## Validation

- `nix fmt -- config/recipe/pi/default.nix config/recipe/pi/permission-mode.nix` formatted the Nix files.
- Evaluated `permission-mode.nix` and the `beleap-m1air` Home Manager entries for the generated permission config and installed extension source.
- Imported the extension with Node's TypeScript strip-types mode to confirm it loads.
- No test suite was run.
