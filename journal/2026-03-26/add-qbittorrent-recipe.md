# Add qBittorrent recipe

## Summary
- Added a dedicated `qbittorrent` recipe that installs `pkgs.qbittorrent` via Home Manager.
- Updated the `personal` recipe to include `qbittorrent` only when `metadata.gui` is enabled.

## Why
- Keep GUI app concerns in a dedicated recipe.
- Avoid enabling qBittorrent on non-GUI personal hosts.

## Notes
- This affects personal GUI hosts (e.g. `beleap-m1air`, `beleap-macmini`) and not headless VM hosts.
