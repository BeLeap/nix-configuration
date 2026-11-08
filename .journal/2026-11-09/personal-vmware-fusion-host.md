# Configure the personal NixOS host for VMware Fusion

- Added `vmware-arm64-Darwin-personal` as an NixOS host without the QEMU VM recipe. The `vmware` recipe enables VMware guest tools, preserves the personal VM's autologin and passwordless sudo settings, and sets `system.stateVersion` to `25.05`.
- Removed the image-build approach after clarification. This host should configure an installed NixOS guest inside VMware Fusion.
- Host evaluation lists the new host, but evaluating `system.build.toplevel` fails because the repository does not define the guest root filesystem or GRUB target. The VMware guest's `/etc/nixos/hardware-configuration.nix` and bootloader settings are required before this host can be applied.
- Alejandra, statix, and deadnix checks passed before the final guest-only recipe edit. Re-run them after adding the guest hardware configuration.

## Follow-up validation

- Alejandra, statix, and deadnix passed after the guest-only recipe change.
- Nix evaluation lists `vmware-arm64-Darwin-personal`, reports `virtualisation.vmware.guest.enable = true`, and reports `system.stateVersion = 25.05`.
- The NixOS toplevel still fails because the guest root filesystem and GRUB target are not defined.

## Makefile-based VMware workflow

- Replaced the missing guest hardware-file dependency with the upstream-style fixed VMware Fusion layout: UEFI systemd-boot, ext4 root label `nixos`, EFI label `boot`, and DHCP on `ens160`. The guest uses `virtualisation.vmware.guest.enable`.
- Added `Makefile` targets for local `switch`, `test`, and `check`, plus remote `vm/copy`, `vm/switch`, and `vm/test`. The Makefile does not partition or format disks.
- Documented the required Fusion guest layout and Makefile commands in `README.md`.
- Validation: Alejandra, Statix, and Deadnix passed. Make dry-runs passed for Darwin, Linux, and remote VM targets. The Darwin target rejects an unset `NIXNAME`. `make check` passed from a VCS-free scratch copy, and the VMware NixOS toplevel derivation evaluated.
- Reference pattern: https://github.com/mitchellh/nixos-config/blob/main/Makefile

## Check target refinement

- Updated `make check` to create a temporary source copy without VCS metadata or local VM artifacts. This keeps new working-copy files visible to Nix flake evaluation and avoids copying the ignored qcow2 file.
- Ran `make check` from the repository; all flake checks and the VMware toplevel evaluation passed.

## Makefile simplification

- The user clarified that the Makefile itself was too verbose. Reduced it from 67 to 33 lines by sharing local `switch`/`test` logic and remote `vm/switch`/`vm/test` logic.
- Simplified `check` to direct flake checks, matching the upstream pattern. I did not rerun this final `check` target. A previous full flake check exceeded 300 seconds.
- Targeted formatting, Statix, and Deadnix checks passed for `config/hosts.nix` and `config/recipe/vmware/default.nix`. Nix evaluation of the VMware toplevel passed from a VCS-free scratch copy. Makefile dry-runs and missing-variable guards passed.
- The full Alejandra check reports unrelated formatting in `config/recipe/overlay/default.nix`; I left that concurrent change untouched.

## Diagnose first remote switch

- The user reported successful SSH and rsync to `192.168.97.128`, followed by a rebuild failure because the guest cannot resolve `github.com` or `cache.nixos.org`. The flake cache settings were also rejected as untrusted.
- Added `--accept-flake-config` to Linux and remote `nixos-rebuild` commands. This resolves the trust warnings, not the guest DNS failure. The NixOS toplevel still needs working DNS to fetch the locked nixpkgs input.
- Verified the updated Makefile commands with dry-runs. The guest network and resolver still require diagnosis from inside the VM.

## VMware guest network interface correction

- The guest reported interface `enp2s0`, DHCP address `192.168.97.128/24`, default gateway `192.168.97.2`, and resolver `192.168.97.2`. `getent hosts github.com` returned no address.
- Changed the VMware recipe DHCP interface from `ens160` to the observed `enp2s0`. This matches the guest interface but does not repair the resolver failure reported by Nix.
- Added `--accept-flake-config` to NixOS rebuild commands. It addresses the flake-trust warnings only.
- Alejandra, Statix, Deadnix, target dry-run, and VMware NixOS toplevel evaluation passed after the interface change.

## Disable EDNS for the VMware NAT DNS proxy

- Mac-side `dig @192.168.97.2 github.com A` returned a malformed EDNS response. `dig +noedns @192.168.97.2 github.com A` returned `20.200.245.247`. Direct DNS to `1.1.1.1` timed out from the Mac.
- The guest resolver file contains `options edns0`. NixOS enables that by default. The user accepted a VMware-only workaround, so `config/recipe/vmware/default.nix` now sets `networking.resolvconf.dnsExtensionMechanism = false`. This disables DNSSEC support for that guest.
- Alejandra, Statix, Deadnix, and NixOS toplevel evaluation passed. Nix evaluation reports the option as `false`.
- The first rebuild still needs a one-time removal of `options edns0` from the running guest resolver file before Nix can fetch the flake. The new system configuration will keep EDNS disabled.

## First rebuild reached Nix build

- After the EDNS workaround, the guest fetched and unpacked the `boda` flake input. The remote `nix build` process then exited with `SIGKILL` (signal 9), which the user identified as an OOM event. DNS no longer blocks flake fetching. The guest memory limit is not yet recorded.

## Reduce remote rebuild memory pressure

- The user preferred not to allocate 8 GiB to the VMware guest. Added `--max-jobs 1 --cores 1` to remote `nixos-rebuild` targets so derivations build serially with one core. This can lower peak build memory at the cost of time.
- Verified the remote command with `make -n vm/switch NIXADDR=192.168.97.128 NIXUSER=root`. The OOM has not yet been retested with the new limits.

- The user reports that the remote rebuild still OOMs after adding `--max-jobs 1 --cores 1`. Further memory changes are paused until the guest memory total and kernel OOM victim log identify whether Nix evaluation or a derivation was killed.

- Guest logs confirm global OOM: `nix` was killed at about 2.0–2.1 GiB RSS on each attempt. The guest has 5.8 GiB RAM and no swap. Single-job limits did not prevent the Nix process itself from reaching memory pressure. A swap file or a small RAM increase remains under consideration; check free root-disk space before choosing swap.

- After increasing guest RAM, `free -h` reports 7.7 GiB total and no swap. The latest OOM log shows the kernel killed `nix` at about 3.2 GiB anonymous RSS. The single-job limit did not stop this Nix process from exceeding available memory. A disk-backed swap file is the next lower-RAM-cost option, pending root filesystem capacity.

## Move NixOS evaluation to macOS

- Timed local evaluation of `vmware-arm64-Darwin-personal` on macOS. `/usr/bin/time -l` reported 2.62 GiB maximum resident size and 3.21 GB peak footprint. This matches the guest OOM process, which used about 3.2 GiB RSS while the guest already used several GiB.
- Updated `vm/switch` and `vm/test` to run `nixos-rebuild-ng` on macOS with `--build-host` and `--target-host` set to the VMware guest. The Mac evaluates the flake; the guest realizes the Linux derivation and activates it. The targets no longer copy the repository automatically. `vm/copy` remains available as a separate target.
- Updated the README for the new workflow. `make -n` output and the installed `nixos-rebuild-ng` option help confirm the command and flags. The remote build has not been run with this workflow.

## Remote build ran out of guest disk space

- The Mac-side evaluation and remote-builder workflow advanced to importing cached store paths on the guest. `nix copy` reported `No space left on device` while importing binutils and gcc; subsequent fish and direnv errors are dependent failures. The user interrupted the run with Ctrl-C.
- The guest store capacity and inode availability are not yet known. Do not run garbage collection or delete generations until space usage and reclaimable paths are checked.

- The user reports running Nix garbage collection after `/nix/store` reached 99
- The user reports running Nix garbage collection after `/nix/store` reached 99%. Their `df` output shows `/` as 3.9 GiB tmpfs and `/nix/store` as a 3.9 GiB overlay, not a normal disk-backed root filesystem. This likely explains the store-space failure and may contribute to OOM. The overlay backing and whether the VM booted the installed system remain unverified.

- The user confirmed they are running the NixOS installer. `findmnt` shows `/` as tmpfs and `/nix/store` as an overlay with `/sysroot/nix/.ro-store` lowerdir. `lsblk -f` shows the installer ISO on `sr0` and no partition/filesystem rows under `nvme0n1`. Remote builds in this environment write to the small RAM-backed store overlay, not an installed root filesystem. The VMware configuration expects a manually installed guest. Do not partition or format the disk without explicit confirmation.

## Add guarded VMware bootstrap target

- Added `vm/bootstrap0` and `bin/vm-bootstrap0` for the observed UEFI NixOS installer and `/dev/nvme0n1` disk. The target creates a 512 MiB EFI filesystem labeled `boot`, an ext4 root labeled `nixos`, and no swap partition. It installs a minimal SSH-enabled bootstrap, disables EDNS for the VMware NAT resolver, and prompts for the root password.
- The target requires `ERASE_VM_DISK=/dev/nvme0n1`, verifies the live installer and unmounted whole disk, then requires the exact remote phrase `WIPE /dev/nvme0n1`. I did not run it.
- Updated the README. `bash -n`, ShellCheck, Make dry-run, and the missing-confirmation guard check passed.

- The first `vm/bootstrap0` run repartitioned and formatted `/dev/nvme0n1`, then failed because `/dev/disk/by-label/nixos` was not available immediately after `mkfs`. The script now triggers udev, validates both labels, and mounts the NVMe partition paths directly. The FAT label is uppercase `BOOT`, and the VMware recipe now uses `/dev/disk/by-label/BOOT`.
- The disk has not been installed yet. The updated bootstrap target has not been run. Bash syntax, ShellCheck, Nix formatting/lints, Nix option evaluation, dry-run, and the missing-confirmation guard check passed.

- Journal correction: an earlier `printf` append used an unescaped percent sign and left a partial line ending in `99`. The next complete bullet records the intended filesystem finding. The partial line remains because journal entries are append-only.
