# Fix Pi Tor and landstrip extension conflict

Changed `tor-shell.ts` to intercept and mutate `bash` tool calls instead of registering its own `bash` tool. This lets `pi-landstrip` remain the sole bash tool owner and removes Pi's duplicate-tool startup failure. User `!`/`!!` commands still use wrapped local bash operations when Tor is active.

Tor activation now fails explicitly when `pi-landstrip` owns bash and sandboxing has not been disabled. Landstrip's allowlist HTTP proxy cannot safely compose with `torsocks`; pretending otherwise could route the proxy's upstream connection outside Tor. Start Pi with `--no-sandbox` when using `--tor` or `/tor on`. Model-provider traffic remains unaffected.

Pi's `getFlag()` only exposes flags registered by the calling extension, so the Tor extension cannot read landstrip's `no-sandbox` flag that way. The compatibility gate checks Pi's CLI arguments instead; this also ensures only an explicit `--no-sandbox` invocation enables the combined mode.

Validation:

- TypeScript syntax/transpilation passed.
- Loading `tor-shell.ts` and `pi-landstrip/index.ts` together with `pi -ne -e ... -e ... --list-models` completed without the previous tool conflict.
- The load check emitted an unrelated sandbox warning because Pi could not create its global settings lock in this agent environment.
