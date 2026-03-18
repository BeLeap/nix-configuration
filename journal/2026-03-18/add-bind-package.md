# Add bind package

- Added `bind` to the shared `base` recipe's `environment.systemPackages` so it is available on hosts that include the base configuration.
- Kept the change atomic and limited to the common package list.
