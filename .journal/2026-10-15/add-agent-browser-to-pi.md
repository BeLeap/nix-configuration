# Add agent-browser to Pi

Added `pi-agent-browser-native` to Pi's declarative package list and exposed the Nix-packaged `agent-browser` CLI on Pi's runtime `PATH`. Kept `pi-chrome` enabled. The CLI is scoped to Pi rather than the shared development environment.

After applying the configuration, run `agent-browser install` from Pi once to install its browser binaries if they are not already present.
