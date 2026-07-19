# Strict Pi Tor containment

Replaced the macOS `torsocks`-injection extension, which could silently leak direct connections, with a separate `torpi` launcher binary and a status-only Pi extension.

## Outcome

The separate `torpi` executable now:

1. starts a dedicated Tor client outside Pi's sandbox;
2. starts a local Privoxy bridge configured with `forward-socks5t`, so hostname resolution happens through Tor;
3. verifies the bridge against `https://check.torproject.org/api/ip` and aborts unless `IsTor` is true;
4. starts Pi under a macOS `sandbox-exec` profile that denies every outbound connection except TCP to that one loopback Privoxy port;
5. sets upper- and lower-case HTTP(S)/ALL proxy variables before Pi starts, covering Pi's Undici model-provider traffic and proxy-aware descendants;
6. stops Pi if Tor or Privoxy exits unexpectedly, and cleans up all session processes and temporary state on exit.

Programs that ignore proxy variables now fail under the inherited network sandbox instead of connecting directly. UDP and other traffic Tor cannot carry is likewise denied. Tor directory cache files are retained under `~/Library/Caches/pi-tor` to improve later startup times; session configuration and process state remain temporary.

Strict containment is startup-only. Regular `pi` has no Tor-specific option or launcher patch; use `torpi` for a contained session. `/tor` reports whether the current process was started by `torpi`; switching modes requires restarting with either `torpi` or regular `pi`. The launcher adds `--no-sandbox` because pi-landstrip's separate per-command HTTP proxy cannot compose with the single-port outer network sandbox; the outer network sandbox remains active, but landstrip's filesystem restrictions are disabled during Tor sessions. The implementation currently supports macOS only.

## Validation

- `node --check config/recipe/pi/torpi-launcher.mjs`
- `alejandra --check config/recipe/pi/default.nix`
- `deadnix --fail config/recipe/pi/default.nix`
- `statix check config/recipe/pi/default.nix`
- Built `darwinConfigurations.beleap-m1air.system` successfully.
- Confirmed the regular managed `pi` wrapper contains no Tor dispatch logic and `pi --version` returns directly.
- Built `torpi --version` bootstrapped and verified Tor, returned Pi 0.80.6, and left no Tor/Privoxy session processes behind.
- Inside the generated sandbox, a normal curl request returned `IsTor: true`; after explicitly removing every proxy variable, a direct request to `1.1.1.1` failed with curl exit 7.
- A real OpenAI Codex provider request made by Pi under strict containment completed successfully with the expected response.

The first uncached Tor bootstrap took roughly two minutes in testing. A later cached bootstrap completed in about eight seconds, although Tor startup remains dependent on network conditions.
