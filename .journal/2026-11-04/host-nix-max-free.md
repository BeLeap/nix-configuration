# Host Nix max-free

## Summary

- Raised the host Nix `max-free` target from 16 GiB to 128 GiB in
  `config/recipe/nix/default.nix`.
- Raised host `min-free` from 8 GiB to 56 GiB, matching the VM setting. During
  builds, host GC now starts below 56 GiB free and aims for 128 GiB free.

## Activation

- `nh darwin switch` attempts for the earlier settings were interrupted during
  long Nix builds, before activation.
- The live `nix config show` values are still `min-free = 8 GiB` and
  `max-free = 16 GiB`; the source changes are not active on the host yet. Re-run
  `nh darwin switch` to apply them; host disk had about 84 GiB free.
