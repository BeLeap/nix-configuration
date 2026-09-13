# Set up 1Password SSH agent

## Outcome

- Added the macOS 1Password SSH agent socket to the Darwin Home Manager SSH configuration:
  `IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"`.
- Added the Linux 1Password SSH agent socket to the NixOS Home Manager SSH configuration:
  `IdentityAgent ~/.1password/agent.sock`.
- Kept the existing 1Password CLI and desktop application configuration unchanged.

## Validation

- Repository-wide Alejandra, deadnix, and statix checks passed.
- `beleap-m1air` Darwin system evaluation and build passed.
- `nh darwin switch --no-nom` applied the configuration to the configured `beleap-m1air` target.
- `ssh -G github.com` resolves the macOS socket path, and `ssh-add -l` through that socket lists two 1Password-managed keys.
- The personal NixOS SSH agent setting evaluates correctly. Its full toplevel evaluation remains blocked by the existing unsupported `ax-cli` package on `aarch64-linux`; that failure was not overridden.

## Version control

- The configuration change is recorded in Jujutsu revision `rplrotyw` with description `1password ssh agent`.
- Existing unrelated TorPi working-copy changes were preserved.
