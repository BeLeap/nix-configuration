# Host Nix max-free

## Summary

- Raised the host Nix `max-free` target from 16 GiB to 128 GiB in
  `config/recipe/nix/default.nix`.
- Kept `min-free` at 8 GiB; host GC still starts only after free space falls
  below that threshold during a build.

## Activation

- `nh darwin switch` for the earlier 64 GiB setting remained in the Nix build
  after more than five minutes and was interrupted before it could be applied.
- The live `nix config show` value is still 16 GiB, so the source change is not
  active on the host yet. Re-run `nh darwin switch` to apply it; host disk had
  about 84 GiB free during the attempt.
