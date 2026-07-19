# Set up tokenomy-pi

Added the beta `tokenomy-pi` package to Pi's declarative global package list, pinned at `0.1.23-beta`. Added `gpt-5.4-mini` to the enabled Codex model cycle because Tokenomy uses it as its default classifier and simple-task model; its existing defaults use `gpt-5.4` for medium work and `gpt-5.5` for complex work.

Added Tokenomy's generated `.pi/tokenomy-cache/` and `.pi/tokenomy-stats.json` paths to the global Git ignore list so its local routing telemetry and cache do not dirty repositories. Raw debug tracing remains disabled by Tokenomy's defaults.

Reviewed the upstream release at npm's published git commit `0393598b969bf63fb8ecc0d314ca74b650f99c9a`. It requires Node 22.19+, while the current environment provides Node 24.16.0. The package is Codex-only beta software and makes optional classifier calls through Pi's authenticated `openai-codex` provider; normal telemetry does not store raw prompts, but opt-in debug tracing can.

Validation:

- `alejandra --check` passed for both changed Nix files.
- `deadnix --fail` passed for both changed Nix files.
- `statix check` passed for both changed Nix files.
- Node's TypeScript syntax check passed for the exact upstream extension source.
- The npm registry reports `0.1.23-beta` as latest with provenance metadata, matching the reviewed git commit and lockfile dependency versions.
- Full Nix evaluation was blocked because this Pi sandbox cannot access the Nix daemon socket.
- Live model listing was blocked by unavailable OpenAI Codex auth in this agent environment; apply the Home Manager configuration, restart Pi, and verify with `/tokenomy status` in an authenticated session.
