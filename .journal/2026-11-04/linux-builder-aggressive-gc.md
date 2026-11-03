# Linux builder aggressive GC

## Summary

- Raised the Linux builder guest `min-free` threshold from 8 GiB to 56 GiB and
  `max-free` from 16 GiB to 60 GiB, so GC runs earlier and aims to retain more
  free space in the guest store filesystem.
- Kept the daily automatic GC schedule.

## Validation and activation

- `nh darwin switch` built the updated Darwin system configuration.
- Activation stopped at the macOS administrator password prompt. The loaded
  `org.nixos.linux-builder` LaunchDaemon still points to the previous builder
  start script, so the new guest GC thresholds are not active yet. Run
  `nh darwin switch` from the configuration repository and authenticate to
  complete activation.
