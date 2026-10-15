# Add agent-browser to Pi

Added `pi-agent-browser-native` to Pi's declarative package list and exposed the Nix-packaged `agent-browser` CLI on Pi's runtime `PATH`. Kept `pi-chrome` enabled. The CLI is scoped to Pi rather than the shared development environment.

After applying the configuration, run `agent-browser install` from Pi once to install its browser binaries if they are not already present.

## Follow-up

Removed the `pi-agent-browser-native` package because its stock-Pi integration adds the full browser playbook to every prompt. Kept the CLI scoped to Pi's runtime `PATH` and added a short `agent-browser` discovery skill to the `agent-skills` recipe. It loads the installed CLI's matching core guidance only for browser tasks; `pi-chrome` remains enabled.

## Follow-up

Moved the `agent-browser` CLI package into `agent-skills` so the binary and its discovery skill are installed together in the user profile. This supersedes the Pi-only PATH placement above.
