`.github/workflows/build.yml` only built Darwin outputs even though `bin/run-vm`
and the host inventory define VM-backed NixOS configurations that are used
locally.

Changed:
- enabled `vm-arm64-Darwin-personal` in the build matrix
- enabled `vm-arm64-Darwin-work` in the build matrix
- fixed the old commented matrix entry typo from `presonal` to `personal`
- removed the stale README caveat claiming CI only built macOS outputs

Intent:
- keep CI aligned with the actual supported `run-vm` workflow
- catch evaluation/build regressions for VM outputs in pull requests and pushes
