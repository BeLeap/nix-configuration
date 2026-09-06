# Debug Build job 101400322562

## Outcome

- Diagnosed the failure in GitHub Actions run 34001202040 / PR #253.
- No repository files were changed.

## Observations

- The failing job is `beleap-m1air` on an arm64 macOS runner.
- `check`, checkout, and Nix installation pass; the failure is in the Darwin system build.
- The first fatal error is:
  - `initrd-linux-6.18.49.drv`
  - required system `aarch64-linux`
  - current system `aarch64-darwin`
- PR #253 changes only `flake.lock`.
- The primary `nixpkgs` lock moves from `5dfba623...` to `a5cc6f2c...`.
- The Nixpkgs comparison identifies the relevant change as `linux_6_18: 6.18.48 -> 6.18.49`.
- The same platform-mismatch failure occurs in the preceding two automated lock-update runs.

## Validation

- The same configuration succeeds locally with the PR nixpkgs revision when the existing `/etc/nix/machines` Linux builder is available.
- The local build log confirms the Linux NixOS system is built through `ssh-ng://builder@linux-builder`.
- The CI runner has no configured Linux builder; it therefore attempts to build the `nix.linux-builder` VM's `aarch64-linux` initrd locally.

## Assessment

- Root cause: a cache/builder dependency in CI, exposed when the kernel update invalidates the cached `6.18.48` Linux-builder initrd.
- This is not a syntax or application-configuration regression in PR #253.
- Durable choices are to provide a Linux builder in the macOS workflow or expose a CI-only Darwin configuration that omits the optional `nix.linux-builder` VM. Reverting the primary nixpkgs lock is only a temporary workaround.

## Follow-up: GitHub Actions Linux builder options

- A macOS GitHub-hosted runner can use an SSH-accessible `aarch64-linux` Nix builder.
- `cachix/install-nix-action` with `enable_kvm: true` does not provision a Linux builder on macOS.
- A separate GitHub-hosted ARM Linux job can build and push Linux-only closure paths to Cachix, but jobs do not share Nix stores or networking automatically.
- Bootstrapping nix-darwin's local `nix.linux-builder` VM inside a fresh macOS job is possible but has a bootstrap/cache dependency and is less reliable than a persistent remote builder.

## Follow-up: beleap-macmini self-hosted runner

- The repository currently has zero registered self-hosted runners.
- `beleap-macmini` can be registered as a macOS ARM64 runner with a custom `beleap-macmini` label; the workflow can route jobs with `[self-hosted, macOS, ARM64, beleap-macmini]`.
- Because the repository is public, personal-machine self-hosted jobs must not process arbitrary fork pull requests. The safer design is self-hosted builds for trusted pushes only, while public PRs remain on GitHub-hosted runners or use the CI-only configuration.
- The runner should run as a dedicated low-privilege macOS account, as a service, with the Mac awake and the existing Nix Linux builder available.
- The locked nix-darwin revision includes the native `services.github-runners` module. It manages `pkgs.github-runner`, launchd, state/work/log directories, registration, labels, and a dedicated `_github-runner` user.
- The module accepts a PAT through `tokenFile`; the token must remain outside the Nix store. A PAT is preferable to a one-hour registration token because the module can request registration tokens when needed.
- Agenix supports Darwin system secrets and decrypts them to `/run/agenix/<name>`; the runner can reference `config.age.secrets.<name>.path` without embedding plaintext in the Nix store.
- The encrypted runner-token file cannot be created by the agent without the actual PAT; the user must create the ciphertext locally or provide an already-encrypted file.
- For this repository-level runner, the fine-grained PAT should be scoped to only `BeLeap/nix-configuration` with Repository permissions → Administration → Read and write; Actions/Contents/Workflow permissions are unnecessary.
- The correct `beleap-macmini` age recipient is the exact value in `lib/agenix/keys.nix`; a prior example had a duplicated `cb` substring and must not be reused.
- `BeLeap` is a personal GitHub account, so GitHub does not provide a personal-account-wide self-hosted runner scope. A fine-grained PAT may select all repositories and use Repository Administration: Read and write, but each runner registration remains tied to one repository URL.
- Added `config/recipe/beleap-macmini/secrets/secrets.nix` declaring `github-runner-token.age` for the Mac mini host key. Nix parsing and Alejandra formatting passed.
- The existing working-copy runner integration remains uncommitted, and its `github-runner-token.age` file is currently empty; a real encrypted PAT is still required before a full Darwin build can succeed.
