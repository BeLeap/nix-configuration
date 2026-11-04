# Allow 16 GiB of Linux builder disk usage

- Changed the 64 GiB Linux builder guest GC thresholds to `min-free = 48 GiB`
  and `max-free = 56 GiB`: allow approximately 16 GiB of total filesystem usage
  before auto-GC, then aim to reduce usage to approximately 8 GiB.
- Validated Nix syntax with `nix-instantiate --parse` and reviewed the diff.
- Configuration was not activated; no CI job was rerun.
