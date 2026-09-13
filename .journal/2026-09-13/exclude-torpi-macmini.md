# Exclude the Mac mini Ollama endpoint from Tor

## Outcome

- Added a Privoxy forwarding exception for `beleap-macmini:11434`, the Tailscale-protected Ollama endpoint used by Pi.
- The exception follows the default `forward-socks5t` rule, so Privoxy's last-match precedence routes only that destination directly while all other proxied traffic remains on Tor.
- Pi's macOS sandbox still allows outbound traffic only to the local Privoxy port; the sandbox was not weakened to permit arbitrary direct network destinations.

## Validation

- `node --check config/recipe/pi/torpi-launcher.mjs` passed.
- `nix-instantiate --parse config/recipe/pi/default.nix` passed.
- `nix build .#darwinConfigurations.beleap-m1air.system --no-link` passed.
- A Privoxy smoke test with an unavailable SOCKS listener returned HTTP 200 from `http://beleap-macmini:11434/api/tags`, confirming the destination used the direct exception instead of Tor.

## Reusable finding

- macOS Seatbelt rejects arbitrary host/IP values in `remote tcp` and `remote ip` network rules; only `*` and `localhost` are accepted on this host. Keeping the direct exception in Privoxy preserves the existing loopback-only sandbox boundary.
