# Add Linux crisis tools to base packages

- Reworked the earlier `bind`-only change into a Linux-specific crisis tooling bundle in the shared `base` recipe.
- Kept the default cross-platform package set small (`vim`, `curl`, `git`) and only add Linux troubleshooting tools on NixOS hosts.
- Added `bcc`, `bind`, `bpftrace`, `ethtool`, `iproute2`, `lsof`, `procps`, `strace`, and `tcpdump` for common DNS, network, process, syscall, and eBPF debugging tasks.
